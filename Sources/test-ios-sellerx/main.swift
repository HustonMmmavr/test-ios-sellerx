import Foundation

func SaveData<T: Encodable>(data: T, path: String) -> Bool {
    do {
        let encoder = JSONEncoder()
        let outData = try encoder.encode(data)
        if !FileManager.default.createFile(atPath: path, contents: outData, attributes: nil) {
            return false
        }
    } catch {
        print(error)
        return false
    }
    return true
}

func ErrorOccoured(fName: String, info: String?) {
    var msg = "Входные файлы некорректны"
    if let info = info {
        msg = info
    }
    
    let err = ErrorJson(message: msg)
    if !SaveData(data: err, path: fName) {
        print(msg)
    }
}

func FillParamsValue(params: Params, draftValues: DraftValues) -> Bool {       
    var paramsArr = params.params
    var vpMap = Dictionary<Int, DraftValue>()
    for draftVal in draftValues.values {
        vpMap[draftVal.id] = draftVal
    }

    while !paramsArr.isEmpty {
        let param = paramsArr.first! // we can unwrap because array not empty
        if param.HasValues() {
            var valId: Int?
            if let mapData = vpMap[param.id] {
                if let vId = mapData.GetIdFromValue() {
                    valId = vId
                } else {
                    return false
                }
            }
            
            // we can unwrap, because values exists
            for value in param.values! {
                if let vId = valId, vId == value.id {
                    param.value = value.title
                }
                
                if value.HasParams() {
                    for vParam in value.params! {
                        paramsArr.append(vParam)
                    }
                }
            }
        } else {
            if let mapData = vpMap[param.id] {
                if let val = mapData.GetValue() {
                    param.value = val
                } else {
                    return false
                }
            }
        }
        paramsArr.removeFirst()
    }
    return true
}



// main
var structureFname: String
var draftFname: String
var outFname: String
var errorFname: String

let args = CommandLine.arguments
if args.count < 5 {
    structureFname = "./Structure.json"
    draftFname = "./Draft_values.json"
    outFname = "./Structure_with_values.json"
    errorFname = "./error.json"
} else {
    structureFname = args[1]
    draftFname = args[2]
    outFname = args[3]
    errorFname = args[4]
}

let structureFile = FileHandle(forReadingAtPath: structureFname)
guard let dataStructure = structureFile?.readDataToEndOfFile() else {
    ErrorOccoured(fName: errorFname, info: nil)
    exit(0)
}
structureFile?.closeFile()

let draftFile = FileHandle(forReadingAtPath: draftFname)
guard let dataDraft = draftFile?.readDataToEndOfFile() else {
    ErrorOccoured(fName: errorFname, info: nil)
    exit(0)
}
draftFile?.closeFile()

var params: Params
var draftValues: DraftValues

do {
    let decoder = JSONDecoder()
    params = try decoder.decode(Params.self, from: dataStructure)
    draftValues = try decoder.decode(DraftValues.self, from: dataDraft)
} catch {
    ErrorOccoured(fName: errorFname, info: nil)
    exit(0)
}

// Main algorithm
if !FillParamsValue(params: params, draftValues: draftValues) {
    ErrorOccoured(fName: errorFname, info: nil)
    exit(0)
}

if !SaveData(data: params, path: outFname) {
    print("eerr")
    ErrorOccoured(fName: errorFname, info: "Возникли проблемы")
}