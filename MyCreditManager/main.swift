//
//  main.swift
//  MyCreditManager
//
//  Created by Mi Gyeong Park on 2023/04/23.
//
//https://www.wanted.co.kr/events/pre_challenge_ios_3
//https://yagomacademy.notion.site/iOS-ba2d0c0bb0b949c896cc28567706e969

import Foundation

class Student
{
    var name: String
    var classes: Array<ClassInfo>
    init(name: String, classes: ClassInfo...){
        self.name = name
        self.classes = classes
    }
}
class ClassInfo
{
    var subject: String
    var grade: String
    init(subject: String, grade: String)
    {
        self.subject = subject
        self.grade = grade
    }
}

//학생명부
var students = [Student]()

//프로그램 실행
while true {

    print("원하는 기능을 입력해주세요")
    print("1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")

    let input = readLine()
    
    switch input {
    case "1":
        addStudent()
    case "2":
        deleteStudent()
    case "3":
        addScore()
    case "4":
        deleteScore()
    case "5":
        averageScore()
    case "X":
        print("프로그램을 종료합니다...")
    default:
        print("잘못된 입력입니다. 1~5 사이의 숫자 혹은 X를 입력하세요")
    }
    
    //print(students.count)
    //프로그램 종료
    if input == "X" {
        break
    }
}

//기능
func addStudent() {
    print("추가할 학생의 이름을 입력해주세요")
    let name = readLine()!
    if !checkInput(input: name) {return}
    
    for student in students {
        if name == student.name {
            print("\(name)는 이미 존재하는 학생입니다. 추가하지 않습니다.")
            return
        }
    }
    let newStudent = Student(name: name)
    students.append(newStudent)
}

func deleteStudent() {
    print("삭제할 학생의 이름을 입력해주세요")
    let name = readLine()!
    if !checkInput(input: name) {return}
    
    if let index = students.firstIndex(where: { $0.name == name }) {
        students.removeAll(where:{ $0.name == name })
        print("\(name) 학생을 삭제하였습니다.")
    } else {
        print("\(name) 학생을 찾지 못했습니다.")
        return
    }

}

func addScore() {
    print("""
    성적을 추가할 학생의 이름, 과목 이름, 성적을 띄어쓰기로 구분하여 차례로 작성해주세요.
    입력예) Mickey Swift A+
    만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.
    """)
    let input = readLine()!
    if !checkInput(input: input) {return}
    
    let info = input.components(separatedBy: " ")
    let name = info[0]
    let subject = info[1]
    let grade = info[2]
    if name.isEmpty || subject.isEmpty || grade.isEmpty {
        print("잘못된 입력입니다. 다시 확인해주세요")
        return
    }
    
    //학생 찾기
    if let index = students.firstIndex(where: { $0.name == name }) {
        //해당 학생의 과목 찾기
        if let i = students[index].classes.firstIndex(where: {$0.subject == subject}) {
            students[index].classes[i].grade = grade //성적은 그냥 덮어쓰기
            print("\(subject) 과목의 성적이 \(grade)로 변경되었습니다.")
        } else {
            //과목이 없으면 추가하기
            students[index].classes.append(ClassInfo(subject: subject, grade: grade))
            print("\(subject) 과목 성적이 \(grade)로 추가되었습니다.")
        }
    } else {
        print("학생을 찾지 못했습니다.")
        return
    }
}

func deleteScore() {
    print("""
    성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.
    입력예) Mickey Swift
    만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.
    """)
    let input = readLine()!
    if !checkInput(input: input) {return}
    
    let info = input.components(separatedBy: " ")
    let name = info[0]
    let subject = info[1]
    if name.isEmpty || subject.isEmpty {
        print("잘못된 입력입니다. 다시 확인해주세요")
        return
    }
    
    //학생 찾기
    if let index = students.firstIndex(where: { $0.name == name }) {
        //해당 학생의 과목 찾기
        if let i = students[index].classes.firstIndex(where: {$0.subject == subject}) {
            students[index].classes.removeAll(where:{ $0.subject == subject })
            print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
        } else {
            //과목이 없으면 추가하기
            print("\(name) 학생의 \(subject) 과목이 없습니다.")
        }
    } else {
        print("학생을 찾지 못했습니다.")
        return
    }
}

func averageScore() {
    print("평점을 알고싶은 학생의 이름을 입력해주세요")
    let name = readLine()!
    if !checkInput(input: name) {return}
    
    if let index = students.firstIndex(where: { $0.name == name }) {
        var totalScore = 0.0
        //해당 학생의 과목과 성적을 모두 출력
        if students[index].classes.count > 0 {
            students[index].classes.forEach{
                print("\($0.subject) : \($0.grade)")
                totalScore += calculateScore(grade: $0.grade)
            }
            //평점을 출력
            print("과목 평점 : \(totalScore / Double(students[index].classes.count))")
        } else {
            print("\(name) 학생의 과목이 없습니다")
        }
        
    } else {
        print("\(name) 학생을 찾지 못했습니다.")
        return
    }
}

func checkInput(input: String) -> Bool {
    if input.isEmpty {
        print("잘못된 입력입니다. 다시 확인해주세요")
        return false
    }
    return true
}

func calculateScore(grade: String) -> Double {
    if grade == "A+" {
        return 4.5
    } else if grade == "A" {
        return 4.0
    } else if grade == "B+" {
        return 3.5
    } else if grade == "B" {
        return 3.0
    } else if grade == "C+" {
        return 2.5
    } else if grade == "C" {
        return 2.0
    } else if grade == "D+" {
        return 1.5
    } else if grade == "D" {
        return 1.0
    } else if grade == "F" {
        return 0.0
    } else {
        print("\(grade) 점수는 존재하지 않습니다.")
        return 0.0 //오류
    }
}
