//
//  BuildView.swift
//  BudgetBuild
//
//  Created by Bryce Nicholson on 7/16/24.
//
import SymbolPicker
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUI
import Charts


// percentage Function
private func calculatePercentage(value: Category?, total: [Category]) -> Double {
    let calcTotal = (total.map{($0.Subcategories.map{$0.amount}.reduce(0,+))}.reduce(0,+) as Double)
    let catTotal = (value!.Subcategories.map{$0.amount}.reduce(0,+) as Double)
    return (catTotal / calcTotal)
}

// currency formatter
private let incomeFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
}()
// percentage formatter
private let percentageFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.maximumFractionDigits = 1
    formatter.minimumFractionDigits = 1
    return formatter
}()

// Sheet for editing amount of subcategory
struct editAmount: View {
    @State var amount: Double = 0
    var subcategory: budgetItem
    @FirestoreQuery var category: [Category]
    
    let db = Firestore.firestore()
    init (subcategory: budgetItem) {
        self._category = FirestoreQuery(collectionPath: "users/\(Auth.auth().currentUser?.uid ?? "")/Categories", predicates: [.whereField("id", isEqualTo: subcategory.catID)])
        self.subcategory = subcategory
    }
    var body: some View {
        TextField("Amount: ", value: $amount, formatter: incomeFormatter)
        
        // Submit Amount
        Button {
            let subCategories = category.first?.Subcategories.filter { $0.id != subcategory.id} ?? []
            var subCategoriesDict: [[String: Any]] = []
            for subcategory in subCategories {
                subCategoriesDict.append(subcategory.asDictionary())
            }
            subCategoriesDict.append(budgetItem(id: subcategory.id, name: subcategory.name, amount: amount, catID: subcategory.catID).asDictionary())
            
            db.collection("users")
                .document(Auth.auth().currentUser?.uid ?? "")
                .collection("Categories")
                .document(category.first?.id ?? "")
                .updateData(["Subcategories": subCategoriesDict]) { err in
                    if let err = err {
                        print("Error on Submission of SubCategory: \(err)")
                    }
                }
        } label: {
            Text("Submit")
        }
    }
}

// Sheet for adding Subcategory
struct AddSubCategorySheet: View {
    @State var title: String = ""
    @State var amount: Double = 0
    var category: Category
    let db = Firestore.firestore()
    var body: some View {
        Text(category.name)
        TextField("Title", text: $title)
        TextField("Amount", value: $amount, formatter: incomeFormatter)
        
        Button {
            db.collection("users")
                .document(Auth.auth().currentUser?.uid ?? "")
                .collection("Categories")
                .document(category.id)
                .updateData(["Subcategories": FieldValue.arrayUnion([budgetItem(id: UUID().uuidString, name: title, amount: 0, catID: category.id).asDictionary()])]) { err in
                    if let err = err {
                        print("Error on Submission of SubCategory: \(err)")
                    }
                }
            
        } label: {
            Text("Submit")
        }
    }
}


// Sheet for adding Category
struct AddCategorySheet: View {
    @State var title: String = ""
    @State var icon: String = ""
    @State var color: Color = Color(.white)
    @State var isIconPickerShowing: Bool = false
    let db = Firestore.firestore()
    var body: some View {
        VStack{
            
            // Title input
            TextField("Title", text: $title)
            
            // Icon Input
            Button {
                isIconPickerShowing.toggle()
            } label: {
                Text("Select Icon")
            }
            
            // Color input
            ColorPicker("Color", selection: $color)
            
            // Submission Button
            Button {
                let newColor = UIColor(color).cgColor.components ?? [1,1,1,1]
                let newCategory = Category(id: UUID().uuidString, name: title, Subcategories: [], color: ["red": newColor[0], "green": newColor[1], "blue": newColor[2]], icon: icon, created: Date().timeIntervalSince1970)
                db.collection("users")
                    .document(Auth.auth().currentUser?.uid ?? "")
                    .collection("Categories")
                    .document(newCategory.id)
                    .setData(newCategory.asDictionary())
            } label: {
                Text("Submit")
            }.backgroundStyle(.green)
        }
        .sheet(isPresented: $isIconPickerShowing){
            SymbolPicker(symbol: $icon)
        }
    }
}


// Each Category Dropdown
struct categoryRow: View {
    var CategoryViewModel: Category
    @Binding var isShowing: Bool
    @Binding var currentCategory: Category?
    @Binding var currentSubcategory: budgetItem?
    private let incomeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    var body: some View {
            DisclosureGroup {
                // Subcategory rows
                ForEach(CategoryViewModel.Subcategories){ SubCategory in
                    budgetRow(SubCategoryViewModel: SubCategory, currentSubcategory: $currentSubcategory)
                       
                }
                // Add Subcategory Button
                Button {
                    currentCategory = CategoryViewModel
                    isShowing.toggle()
                } label: {
                    HStack{
                        Image(systemName: "plus")
                        Text("Add Subcategory")
                    }
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(Color(red: 240/255, green: 240/255, blue: 240/255)))
                }
            } label: {
                HStack{
                    Image(systemName: CategoryViewModel.icon).padding(.trailing)
                    Text(CategoryViewModel.name)
                    Spacer()
                    Text(incomeFormatter.string(from: (CategoryViewModel.Subcategories.map{$0.amount}.reduce(0,+) as NSNumber))!)
                        .padding(2)
                        .background(RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(Color(red: 240/255, green: 240/255, blue: 240/255)))
                }
            }
            .tint(.black)

    }
}


// Each Subcategory row in BuildView
struct budgetRow: View {
    var SubCategoryViewModel: budgetItem
    @Binding var currentSubcategory: budgetItem?
    private let selectedOptions = [
        "Housing",
        "Saving",
        "Food",
        "Insurance",
        "Other"
    ]
    
    var body: some View{
        //Label for SubCategory Row
        HStack {
            Text(SubCategoryViewModel.name)
            Spacer()
            Text(incomeFormatter.string(from: SubCategoryViewModel.amount as NSNumber)!).onTapGesture {
                    currentSubcategory = SubCategoryViewModel
            }
            .padding(2)
            .background(RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(Color(red: 240/255, green: 240/255, blue: 240/255)))
            
        }
        // On tap activate edit sheet
    }
}


struct BuildView: View {
    @ObservedObject var viewModel = BuildViewModel()
    @FirestoreQuery var currentBudget: [Category]
    @State private var showingAddCategorySheet = false
    @State private var showingAddSubCategorySheet = false
    @State private var settingsDetent = PresentationDetent.medium
    @State private var currentCategory: Category? = nil
    @State private var currentSubcategory: budgetItem? = nil
    @State private var charDescIsShowing: Bool = false

    init(userId: String) {
        self._currentBudget = FirestoreQuery(collectionPath: "users/\(userId)/Categories")
    }
    private let selectedOptions = [
    "Weekly",
    "Bi-Weekly",
    "Monthly",
    "Annually"
    ]

    var addBudgetItemButton: some View {
        HStack{
            Spacer()
            HStack{
                Image(systemName: "plus")
                Text("Budget Item")
            }
            .onTapGesture {
                let _ = print(self.currentBudget)
                showingAddCategorySheet.toggle()
            }
            .font(.headline)
            .padding(12)
            .foregroundColor(.green)
            .background(.white)
            .clipShape(Capsule())
            Spacer()
        }.padding()
    }
    var body: some View {
        let _ = Self._printChanges()
        NavigationView{
            VStack{
                Text("Budget")
                    .bold()
                
                List {
                    Section{
                       
                        HStack {
                            VStack {
                                Spacer()
                                Button  {
                                    withAnimation() {
                                        charDescIsShowing.toggle()
                                    }
                                } label : {
                                    ZStack(alignment: .center) {
                                        RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(Color(red: 240/255, green: 240/255, blue: 240/255)).padding(-4)
                                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    }
                                }.frame(width: 13, height: 13, alignment: .bottomLeading)
                                    .padding(4)
                                    .buttonStyle(BorderlessButtonStyle())
                            }.frame(alignment: .bottomLeading)
                                Chart (currentBudget) { category in
                                    SectorMark(angle: .value(
                                        Text(verbatim: category.name),
                                        category.Subcategories.map{$0.amount}.reduce(0,+)
                                    ),
                                               innerRadius: .ratio(0.8)
                                    )
                                    .foregroundStyle(Color(red: (category.color["red"] ?? 0), green: (category.color["green"] ?? 0), blue: (category.color["blue"] ?? 0), opacity: (category.color["opacity"] ?? 1)))
                                    
                                }

                            Spacer()
                            VStack {
                                Text("Monthly")
                                Text(incomeFormatter.string(from: (currentBudget.map{($0.Subcategories.map{$0.amount}.reduce(0,+))}.reduce(0,+) as NSNumber))!)
                            }
                            }
                        if charDescIsShowing {
                        VStack {
                            ForEach (currentBudget) { category in
                                if (category.Subcategories.map{$0.amount}.reduce(0,+) > 0) {
                                    GeometryReader { geometry in
                                        HStack {
                                            ZStack(alignment: .center) {
                                                RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(Color(red: (category.color["red"] ?? 0), green: (category.color["green"] ?? 0), blue: (category.color["blue"] ?? 0), opacity: (category.color["opacity"] ?? 1)))
                                                Image(systemName: category.icon)
                                            }.frame(width: geometry.size.width/10)
                                            Text(category.name).font(.system(size: 14))
                                            Spacer()
                                                
                                            Text(incomeFormatter.string(from: (category.Subcategories.map{$0.amount}.reduce(0,+) as NSNumber))!).font(.system(size: 14))
                                            Text("(\(percentageFormatter.string(from: calculatePercentage(value: category, total: currentBudget) as NSNumber)!))").font(.system(size: 14))
                                        }
                                    }.padding(10)
                                }
                            }
                        }
                        }
                    }

                    // Rows for Budget Items
                    ForEach(currentBudget) { CategoryViewModel in
                        Section{
                            categoryRow(CategoryViewModel: CategoryViewModel, isShowing: $showingAddSubCategorySheet, currentCategory: $currentCategory, currentSubcategory: $currentSubcategory)
                        }.listRowBackground(Color(red: (CategoryViewModel.color["red"] ?? 0), green: (CategoryViewModel.color["green"] ?? 0), blue: (CategoryViewModel.color["blue"] ?? 0), opacity: (CategoryViewModel.color["opacity"] ?? 1)))
                    }
                    
                    // Add item button
                    Section(footer: addBudgetItemButton){}
                    

                }.listSectionSpacing(4)
                    .sheet(item: $currentCategory) { item in
                        AddSubCategorySheet(category: item)
                    }
                    .sheet(isPresented: $showingAddCategorySheet) {
                        AddCategorySheet().presentationDetents([.medium], selection: $settingsDetent)
                    }
                    .sheet(item: $currentSubcategory) { subcategory in
                        editAmount(subcategory: subcategory)
                    }
                    
                
            }
            
        }
    }
}

#Preview {
    BuildView(userId: "123")
}
