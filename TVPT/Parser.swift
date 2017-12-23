import Foundation

class Entry {
    var isRadio: Bool = false
    var title: String?
    var url: String?
}

extension Entry: Equatable {
    static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.title == rhs.title
    }
}

struct Parser {

    static func parse(file: String) -> [Entry] {
        var entries: [Entry] = []
        var currentEntry: Entry?
        
        file.enumerateLines(invoking: { line, stop in
            
            if line.hasPrefix("#EXTINF:") {
                guard !self.shouldBeExcluded(line: line) else { return }
                
                currentEntry = Entry()
                currentEntry?.title = Array(line.components(separatedBy: ",")).last
                currentEntry?.isRadio = determineIfRadio(line: line)
                
            } else if currentEntry != nil { // current entry being parsed atm
                guard !self.shouldBeExcluded(line: line) else {
                    currentEntry = nil
                    return
                }
                
                currentEntry?.url = Array(line.components(separatedBy: "|")).first
                
                guard let entry = currentEntry, let entryUrl = entry.url, let url = URL(string: entryUrl) else {
                    currentEntry = nil
                    return
                }
                
                if !entries.contains(entry) {
                    entries.append(entry)
                }
                
                currentEntry = nil
            }
        })
        
        return entries
    }
    
    private static func shouldBeExcluded(line: String) -> Bool {
        let excluded = ["INFORMACAO", "beachcam", "SANTUARIO", "Geo-Bloqueado", "CANCAO NOVA", "ARROIOS TV", "AGUEDA TV", " (US)", " (FR)", " (IT)", " (INT.)", " (DE)", " (ALE)", "radio=\"true\""]
        
        for excludedWord in excluded {
            if line.lowercased().contains(excludedWord.lowercased()) {
                return true
            }
        }
        
        return false
    }
    
    private static func determineIfRadio(line: String) -> Bool {
        let radioIdentifier = "radio=\"true\""
        
        return line.lowercased().contains(radioIdentifier.lowercased())
    }
}
