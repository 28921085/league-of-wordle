//
//  ContentView.swift
//  league of wordle
//
//  Created by 1+ on 2022/3/31.
//

import SwiftUI

struct ContentView: View {
    @State private var keyboard:[String]=["ㄅㄆㄇㄈ","ㄉㄊㄋㄌ","⇤ㄍㄎㄏ","⟳ㄐㄑㄒ","ㄓㄔㄕㄖ","↵ㄗㄘㄙ","ㄦㄧㄨㄩ","ㄚㄛㄜㄝ","ㄞㄟㄠㄡ","ㄢㄣㄤㄥ"]
    @State private var keyboard_color:[[Int]]=Array(repeating: Array(repeating: 0, count: 4), count: 10)
    @State private var input:[String]=[]
    @State private var maxlen:Int=5
    @State private var len:Int=0
    @State private var ans_zu:String=""
    @State private var ans_ch:String=""
    @State private var guess:Int=6
    @State private var guess_now:Int=0
    @State private var record:[[String]]=Array(repeating: Array(repeating: "  ", count: 5), count: 6)
    @State private var result_record:[[Int]]=Array(repeating: Array(repeating: 0, count: 5), count: 6)
    @State private var alertTitle:String=""
    @State private var warning:Bool=false
    @State private var data:[[String]]=Array(repeating:[], count: 25)
    @State private var data_ans:[[String]]=Array(repeating:[], count: 25)
    @State private var correct=Color(.sRGB,red:0.0,green: 1.0,blue: 0.0)
    @State private var wrong_pos=Color(.sRGB,red: 1.0,green: 1.0,blue: 0.0)
    @State private var wrong=Color(.sRGB,red: 0.2,green: 0.2,blue: 0.2)
    @State private var game_end:Int=0
    @State private var title:String="League Of Wordle"
    func judge(){//a line
        var str=Array(ans_zu)
        var result=Array(repeating: 3, count: maxlen)
        for i in(0..<maxlen){
            if String(str[i]) == record[guess_now][i]{
                str[i]="0"
                result[i]=1
            }
        }
        for i in(0..<maxlen){
            for j in(0..<maxlen){
                if String(str[i]) == record[guess_now][j] && String(str[i]) != "0"{
                    str[i]="0"
                    result[j]=2
                }
            }
        }
        str=Array(ans_zu)
        for i in(0..<maxlen){
            for j in(0..<10){
                for k in(0..<4){
                    let idx:String.Index=keyboard[j].index(keyboard[j].startIndex,offsetBy:k)
                    if String(keyboard[j][idx...idx]) == record[guess_now][i]{
                        if keyboard_color[j][k] == 0{
                            keyboard_color[j][k] = result[i]
                        }
                        else{
                            keyboard_color[j][k] = min(keyboard_color[j][k],result[i])
                        }
                    }
                }
            }
        }
        //animate
        for i in (0..<maxlen){
            result_record[guess_now][i]=result[i]
        }
    }
    var body: some View {
        VStack{
            Text(title).font(.largeTitle).position(x: 170, y: 0)
                .onAppear{
                    if let asset = NSDataAsset(name:"quiz"),
                       let content = String(data: asset.data,encoding: .utf8),
                        let asset2 = NSDataAsset(name:"ans"),
                       let content2 = String(data: asset2.data,encoding: .utf8){
                        let array = content.split(separator: "\r\n")
                        let array2 = content2.split(separator: "\r\n")
                        for i in (0..<Int(array.count)){
                            let n = array[i].count
                            data[n].append(String(array[i]))
                            data_ans[n].append(String(array2[i]))
                        }
                        let idx=Int.random(in: 0..<Int(data[maxlen].count))
                        ans_zu = data[maxlen][idx]
                        ans_ch = data_ans[maxlen][idx]
                    }
                    record=Array(repeating: Array(repeating: "  ", count: maxlen), count: guess)
                    result_record=Array(repeating: Array(repeating: 0, count: maxlen), count: guess)
                    keyboard_color=Array(repeating: Array(repeating: 0, count: 4), count: 10)
                }
            //Text(ans_zu+ans_ch)
            VStack(spacing:5){//guesses
                ForEach(0..<guess){i in
                    HStack(spacing:5){
                        ForEach(0..<maxlen){j in
                            if result_record[i][j] == 0{//init
                                Rectangle().fill(Color.gray).frame(width: CGFloat(250/maxlen), height: CGFloat(280/maxlen))
                                    .overlay(Text(record[i][j]).font(.system(size:CGFloat(250/maxlen))))
                            }
                            else if result_record[i][j] == 1{//correct
                                Rectangle().fill(correct).frame(width: CGFloat(250/maxlen), height: CGFloat(280/maxlen))
                                    .overlay(Text(record[i][j]).font(.system(size:CGFloat(250/maxlen))))
                            }
                            else if result_record[i][j] == 2{//wrong position
                                Rectangle().fill(wrong_pos).frame(width: CGFloat(250/maxlen), height: CGFloat(280/maxlen))
                                    .overlay(Text(record[i][j]).font(.system(size:CGFloat(250/maxlen))))
                            }
                            else{//wrong
                                Rectangle().fill(wrong).frame(width: CGFloat(250/maxlen), height: CGFloat(280/maxlen))
                                    .overlay(Text(record[i][j]).font(.system(size:CGFloat(250/maxlen))))
                            }
                        }
                    }
                }
            }
            HStack(spacing:2){//keyboard
                ForEach(0..<10){i in
                    VStack(spacing:2){
                        ForEach(0..<4){j in
                            Button{
                                if game_end == 0{
                                    let idx:String.Index=keyboard[i].index(keyboard[i].startIndex,offsetBy:j)
                                    if keyboard[i][idx...idx] == "⇤"{
                                        if len != 0{
                                            len-=1
                                            record[guess_now][len]=" "
                                        }
                                    }
                                    else if keyboard[i][idx...idx] == "↵"{
                                        if len == maxlen{
                                            var str:String = record[guess_now].joined()
                                            if str==ans_zu{
                                                judge()
                                                warning = true
                                                title=("answer:"+ans_ch)
                                                alertTitle = "correct"
                                                game_end=1
                                            }
                                            else{
                                                if let tmp = data[maxlen].first(where:{$0 == str}){
                                                    judge()
                                                    guess_now+=1
                                                    len=0
                                                    if guess_now == guess{
                                                        title=("answer:"+ans_ch)
                                                        alertTitle="You lose"
                                                        warning=true
                                                        game_end=1
                                                    }
                                                }
                                                else{
                                                    warning=true
                                                    alertTitle="input word not found"
                                                }
                                            }
                                        }
                                        else{
                                            warning=true
                                            alertTitle = "not enough words"
                                        }
                                    }
                                    else if keyboard[i][idx...idx] == "⟳"{
                                        len=0
                                        record[guess_now] = Array(repeating: "  ", count: maxlen)
                                    }
                                    else if len != maxlen{
                                        record[guess_now][len] = (""+keyboard[i][idx...idx])
                                        len+=1
                                    }
                                }
                            }label:{
                                let idx:String.Index=keyboard[i].index(keyboard[i].startIndex,offsetBy:j)
                                if keyboard[i][idx...idx]=="⇤" || keyboard[i][idx...idx]=="↵" || keyboard[i][idx...idx]=="⟳"{
                                    Text(""+keyboard[i][idx...idx]).font(.system(size: 30)).foregroundColor(Color.gray)
                                }
                                else{
                                    if keyboard_color[i][j] == 0{
                                        Text(""+keyboard[i][idx...idx]).font(.system(size: 30)).background(Color.purple).foregroundColor(Color.white)
                                    }
                                    else if keyboard_color[i][j] == 1{
                                        Text(""+keyboard[i][idx...idx]).font(.system(size: 30)).background(correct).foregroundColor(Color.white)
                                    }
                                    else if keyboard_color[i][j] == 2{
                                        Text(""+keyboard[i][idx...idx]).font(.system(size: 30)).background(wrong_pos).foregroundColor(Color.white)
                                    }
                                    else if keyboard_color[i][j] == 3{
                                        Text(""+keyboard[i][idx...idx]).font(.system(size: 30)).background(wrong).foregroundColor(Color.white)
                                    }
                                    
                                }
                            }
                            .alert(alertTitle,isPresented:$warning,actions:{
                                Button("OK"){}
                            })
                        }
                    }
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
