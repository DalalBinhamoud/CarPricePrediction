import CoreML
import SwiftUI

struct ContentView: View {

    //MARK: - Variables
    @State private var selectedCarName = ""
    @State private var selectedYear: Int = 2023
    @State private var miles = 0
    @State private var result = 0.0

    let model = try! carvana(configuration: MLModelConfiguration())

    private var cars: [Car] {
        guard let fileURL = Bundle.main.url(forResource: "carNames", withExtension: "json") else { 
            fatalError("Failed to load json file")
        }

        do {
            let jsonData = try Data(contentsOf: fileURL)
            let cars = try JSONDecoder().decode([Car].self, from: jsonData)
            return cars
        } catch {
            return []
        }
    }

    //MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Text("Find Car price")
                .font(.title.weight(.bold))

            VStack(alignment: .leading) {
                Picker("Select Car",  selection: $selectedCarName) {
                    ForEach(cars, id:\.self) {
                        Text($0.name).tag($0.name)
                    }
                }

                Picker("Select Year", selection: $selectedYear) {
                    ForEach(getLast5Years(), id:\.self) {
                        Text("\($0)").tag($0)
                    }
                }

                TextField("enter driven miles", value: $miles, format: .number)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            .background(Color.cyan)

            Text("\(result) $")
                .font(.title.weight(.bold))
                .foregroundStyle(.green)

            Button("Get Car Price") {

                do {
                    let res = try model.prediction(Name: selectedCarName, Year: Double(selectedYear), Miles: Double(miles))

                    result = res.Price
                } catch {
                    print(error.localizedDescription)
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    //MARK: - Methods

    // last 5 years
    private func getLast5Years() -> [Int] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        var last5Years: [Int] = []

        for index in 0...5 {
            last5Years.append(currentYear - index)
        }
        return last5Years
    }
}

#Preview {
    ContentView()
}
