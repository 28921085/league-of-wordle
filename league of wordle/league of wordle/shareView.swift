//
//  shareView.swift
//  league of wordle
//
//  Created by 1+ on 2022/4/4.
//

import SwiftUI

struct shareView: View {
  var color:Int = 0
    @Binding  var record:[[rec]]
    @Binding var change:Int
    @Binding var title:String
    var body: some View {
        VStack(spacing:10){
            if title == "correct"{
                Text("WIN !!!").font(.largeTitle)
            }
            else{
                Text("LOSE !!!").font(.largeTitle)
            }
            ForEach (record.indices, id:\.self){ i in
                HStack(spacing:10){
                    ForEach (record[i].indices, id:\.self){ j in
                        if record[i][j].color == 1{
                            Text("🟩")
                        }
                        else if record[i][j].color == 2{
                            Text("🟨")
                        }
                        else if record[i][j].color == 3{
                            Text("⬛️")
                        }
                    }
                }
            }
            Button{
                change=0
            }label:{
                Text("Back")
            }
        }
    }
}


