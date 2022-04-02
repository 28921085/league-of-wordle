//
//  ContentView.swift
//  league of wordle
//
//  Created by 1+ on 2022/3/31.
//

import SwiftUI

struct ContentView: View {
    @State private var str:[String]=["ㄅㄆㄇㄈ","ㄉㄊㄋㄌ","⇤ㄍㄎㄏ","⟳ㄐㄑㄒ","ㄓㄔㄕㄖ","↵ㄗㄘㄙ","ㄦㄧㄨㄩ","ㄚㄛㄜㄝ","ㄞㄟㄠㄡ","ㄢㄣㄤㄥ"]
    @State private var input:[String]=[]
    @State private var maxlen:Int=5
    @State private var len:Int=0
    @State private var ans_zu:String=""
    @State private var ans_ch:String=""
    @State private var guess:Int=6
    @State private var guess_now:Int=0
    @State private var record:[[String]]=Array(repeating: Array(repeating: "  ", count: 5), count: 6)
    @State private var alertTitle:String=""
    @State private var warning:Bool=false
    @State private var data:[[String]]=Array(repeating:[], count: 25)
    var body: some View {
        VStack{
            Text("League Of Wordle").font(.largeTitle).position(x: 170, y: 0)
                .onAppear{
                    if let asset = NSDataAsset(name:"quiz"),
                       let content = String(data: asset.data,encoding: .utf8){
                        let array = content.split(separator: "\r\n")
                        for i in array{
                            let n = i.count
                            data[n].append(String(i))
                        }
                        ans_zu = data[maxlen].randomElement()!
                    }
                    record=Array(repeating: Array(repeating: "  ", count: maxlen), count: guess)
                }
            Text(ans_zu)
            VStack(spacing:5){
                ForEach(0..<guess){i in
                    HStack(spacing:5){
                        ForEach(0..<maxlen){j in
                            Rectangle().fill(Color.gray).frame(width: CGFloat(280/maxlen), height: CGFloat(280/maxlen))
                                .overlay(Text(record[i][j]).font(.system(size:CGFloat(250/maxlen))))
                        }
                    }
                }
            }
            /*HStack{
                ForEach(input.indices,id:\.self){i in
                    Text(input[i])
                }
            }*/
            HStack(spacing:2){//keyboard
                ForEach(0..<10){i in
                    VStack(spacing:2){
                        ForEach(0..<4){j in
                            Button{
                                let idx:String.Index=str[i].index(str[i].startIndex,offsetBy:j)
                                if str[i][idx...idx] == "⇤"{
                                    if len != 0{
                                        len-=1
                                        record[guess_now][len]="  "
                                    }
                                }
                                else if str[i][idx...idx] == "↵"{
                                    if len == maxlen{
                                        var str:String = record[guess_now].joined()
                                        if str==ans_zu{
                                            warning = true
                                            alertTitle = "correct"
                                        }
                                        else{
                                            if let tmp = data[maxlen].first(where:{$0 == str}){
                                                
                                                guess_now+=1
                                                len=0
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
                                else if str[i][idx...idx] == "⟳"{
                                    len=0
                                    record[guess_now] = Array(repeating: "  ", count: maxlen)
                                    //input=[]
                                }
                                else if len != maxlen{
                                    //input.append(""+str[i][idx...idx])
                                    record[guess_now][len] = (""+str[i][idx...idx])
                                    len+=1
                                }
                            }label:{
                                let idx:String.Index=str[i].index(str[i].startIndex,offsetBy:j)
                                if str[i][idx...idx]=="⇤" || str[i][idx...idx]=="↵" || str[i][idx...idx]=="⟳"{
                                    Text(""+str[i][idx...idx]).font(.system(size: 30)).foregroundColor(Color.gray)
                                }
                                else{
                                    Text(""+str[i][idx...idx]).font(.system(size: 30)).background(Color.purple).foregroundColor(Color.white)
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
