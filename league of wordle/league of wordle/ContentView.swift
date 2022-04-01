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
    var body: some View {
        VStack{
            
            Text("League Of Wordle").font(.largeTitle).position(x: 170, y: 0)
            HStack{
               /* ForEach(0..<len){ inp in
                    Text(input[inp])
                }*/
                ForEach(input.indices,id:\.self){i in
                    Text(input[i])
                }
            }
            HStack(spacing:2){//keyboard
                ForEach(0..<10){i in
                    VStack(spacing:2){
                        //for j in str[i]{
                        ForEach(0..<4){j in
                          
                            Button(action:{
                                let idx:String.Index=str[i].index(str[i].startIndex,offsetBy:j)
                                if str[i][idx...idx] == "⇤"{
                                    if len != 0{
                                        len-=1
                                        input.removeLast()
                                    }
                                }
                                else if str[i][idx...idx] == "↵"{
                                    if len == maxlen{
                                        if let quiz=NSDataAsset(name: "quiz"){
                                            
                                        }
                                    }
                                }
                                else if str[i][idx...idx] == "⟳"{
                                    len=0
                                    input=[]
                                }
                                else if len != maxlen{
                                    input.append(""+str[i][idx...idx])
                                    len+=1
                                }
                                
                            }){
                                
                                let idx:String.Index=str[i].index(str[i].startIndex,offsetBy:j)
                                if str[i][idx...idx]=="⇤" || str[i][idx...idx]=="↵" || str[i][idx...idx]=="⟳"{
                                    Text(""+str[i][idx...idx]).font(.system(size: 30)).foregroundColor(Color.gray)
                                }
                                else{
                                    Text(""+str[i][idx...idx]).font(.system(size: 30)).background(Color.purple).foregroundColor(Color.white)
                                }
                                
                            }
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
