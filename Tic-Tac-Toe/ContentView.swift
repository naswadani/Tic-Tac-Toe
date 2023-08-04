//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by naswakhansa on 04/08/23.
//

import SwiftUI


struct ContentView: View {
    let coloums : [GridItem] = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),]
    @State private var moves : [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameDisabled = false
    @State private var isNight : Bool = false
    var body: some View {
        ZStack{
            BackGroundColor(TopColor : isNight ? .black : .white , BottomColor: isNight ? .gray : .pink)
                GeometryReader{ geometry in
                    VStack{
                        Text("Tic Tac Toe").font(.headline).fontWeight(.semibold).foregroundColor(isNight ? .white : .black)
                        Spacer()
                        LazyVGrid(columns: coloums, spacing: 5 ){
                            ForEach(0..<9){ i in
                                ZStack{
                                    Circle().foregroundColor(.white).opacity(0.5)
                                        .frame(width: geometry.size.width/3 - 20,
                                               height: geometry.size.width/3 - 20)
                                    Circle().foregroundColor(isNight ? .gray : .pink.opacity(0.5))
                                        .frame(width: geometry.size.width/3 - 50,
                                               height: geometry.size.width/3 - 50)
                                    Image(systemName: moves[i]?.indicator ?? "")
                                        .resizable()
                                        .foregroundColor(isNight ? .black : .white)
                                        .fontWeight(.bold)
                                        .frame(width: 40, height: 40)
                                }.onTapGesture {
                                    if isCircleOccupied(in: moves, forIndex: i){ return }
                                    moves[i] = Move(player: .human, boardIndex: i)
                                    isGameDisabled = true
                                    if CheckWinCondition(for: .human, in: moves){
                                        print("Human Wins")
                                    }
                                    if CheckDrawCondition(in: moves){
                                        print("Draw")
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                        let ComputerPosition = determineComputerPosition(in: moves)
                                        moves[ComputerPosition] = Move(player: .computer, boardIndex: ComputerPosition)
                                        if CheckWinCondition(for: .computer, in: moves){
                                            print("Computer Wins")
                                        }
                                        isGameDisabled = false
                                    }
                                    
                                }
                            }
                        }.disabled(isGameDisabled)
                        Spacer()
                        //ButtonChangeTheme(NightVision: $isNight)
                    }.padding()
            }
        }
    }
    func isCircleOccupied(in moves:[Move?], forIndex index : Int) -> Bool{
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    func determineComputerPosition(in moves:[Move?]) -> Int{
        var movePostion = Int.random(in: 0..<9)
        while isCircleOccupied(in: moves, forIndex: movePostion){
            movePostion = Int.random(in: 0..<9)
        }
        return movePostion
    }
    
    func CheckWinCondition (for player : Player, in moves : [Move?]) -> Bool{
        let winPattern : Set<Set<Int>> = [[0,1,2] , [3,4,5] , [6,7,8] , [0,3,6] , [1,4,7] , [2,5,8] , [0,4,8] , [2,4,6]]
        
        let playerMoves = moves.compactMap{ $0 }.filter{$0.player == player}
        let playerPositions = Set(playerMoves.map{ $0.boardIndex })
        
        for pattern in winPattern where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func CheckDrawCondition (in moves : [Move?])->Bool{
        return moves.compactMap{ $0 }.count == 9
    }
}

enum Player{
    case human,computer
}

struct Move{
    let player : Player
    let boardIndex : Int
    
    var indicator : String{ return player == .human ? "xmark" : "circle" }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BackGroundColor: View {
    var TopColor : Color
    var BottomColor : Color
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [TopColor, BottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
    }
}

struct ButtonChangeTheme: View {
    @Binding var NightVision : Bool
    var body: some View {
        Button{
            NightVision.toggle()
        }label: {
            Text("Change Theme")
                .frame(width: 280, height: 50)
                .background(NightVision ? .white : .black)
                .foregroundColor(NightVision ? .black : .white)
                .cornerRadius(20)
                .font(.system(size: 20, weight: .bold, design: .default))
        }
    }
}
