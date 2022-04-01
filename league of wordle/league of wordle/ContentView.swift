//
//  ContentView.swift
//  league of wordle
//
//  Created by 1+ on 2022/3/31.
//

import SwiftUI

struct ContentView: View {
    @State private var str:[String]=["ㄅㄆㄇㄈ","ㄉㄊㄋㄌ","#ㄍㄎㄏ","$ㄐㄑㄒ","ㄓㄔㄕㄖ","^ㄗㄘㄙ","ㄦㄧㄨㄩ","ㄚㄛㄜㄝ","ㄞㄟㄠㄡ","ㄢㄣㄤㄥ"]
    @State private var input:[String]=[]
    @State private var maxlen:Int=5
    @State private var len:Int=0
    var body: some View {
        VStack{
            HStack{
               /* ForEach(0..<len){ inp in
                    Text(input[inp])
                }*/
                ForEach(input.indices){i in
                    Text(input[i])
                }
            }
            HStack(spacing:1){//keyboard
                ForEach(0..<10){i in
                    VStack(spacing:1){
                        //for j in str[i]{
                        ForEach(0..<4){j in
                          
                            Button(action:{
                                let idx:String.Index=str[i].index(str[i].startIndex,offsetBy:j)
                                input.append(""+str[i][idx...idx])
                                len+=1
                            }){
                                
                                let idx:String.Index=str[i].index(str[i].startIndex,offsetBy:j)
                                Text(""+str[i][idx...idx]).font(.system(size: 30))
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
