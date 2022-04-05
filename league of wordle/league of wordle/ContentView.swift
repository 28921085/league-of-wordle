import SwiftUI
import AVFoundation

struct rec{
    var word:String = " "
    var color:Int = 0
}
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
    @State private var record:[[rec]]=Array(repeating: Array(repeating: rec(), count: 5), count: 6)
    @State private var alertTitle:String=""
    @State private var warning:Bool=false
    @State private var data:[[String]]=Array(repeating:[], count: 25)
    @State private var data_ans:[[String]]=Array(repeating:[], count: 25)
    @State private var correct=Color(.sRGB,red:0.0,green: 1.0,blue: 0.0)
    @State private var wrong_pos=Color(.sRGB,red: 1.0,green: 1.0,blue: 0.0)
    @State private var wrong=Color(.sRGB,red: 0.2,green: 0.2,blue: 0.2)
    @State private var game_end:Int=0
    @State private var title:String="League Of Wordle"
    @State private var change_page:Int=0
    @State private var lock:Int=0
    let player = AVPlayer()
    let player2 = AVPlayer()
    func judge(win:Int){//a line
        lock=1
        var str=Array(ans_zu)
        var result=Array(repeating: 3, count: maxlen)
        for i in(0..<maxlen){
            if String(str[i]) == record[guess_now][i].word{
                str[i]="0"
                result[i]=1
            }
        }
        for i in(0..<maxlen){
            for j in(0..<maxlen){
                if String(str[i]) == record[guess_now][j].word && String(str[i]) != "0"{
                    str[i]="0"
                    if result[j] != 1{
                        result[j]=2
                    }
                }
            }
        }
        str=Array(ans_zu)
        //animate
        var ii:Int=0
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) {t in
            var shine:Int=0
            Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) {tim in
                shine+=1
                if shine % 2 == 1 {
                    record[guess_now][ii].color=result[ii]
                }
                else{
                    record[guess_now][ii].color=0
                }
                if shine == 4{
                    record[guess_now][ii].color=result[ii]
                    ii+=1
                    tim.invalidate()
                    if ii == maxlen{
                        for i in(0..<maxlen){
                            for j in(0..<10){
                                for k in(0..<4){
                                    let idx:String.Index=keyboard[j].index(keyboard[j].startIndex,offsetBy:k)
                                    if String(keyboard[j][idx...idx]) == record[guess_now][i].word{
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
                        guess_now+=1
                        len=0
                        lock=0
                        if win == 0{
                            
                            title=("answer:"+ans_ch)
                            alertTitle="You lose"
                            warning=true
                            game_end=1
                            let fileUrl = Bundle.main.url(forResource: "laugh", withExtension: "mp3")!
                            let playerItem = AVPlayerItem(url: fileUrl)
                            self.player2.replaceCurrentItem(with: playerItem)
                            self.player2.play()
                            
                        }
                        t.invalidate()
                    }
                }
            }
        }
        
        
        /*for i in (0..<maxlen){
            record[guess_now][i].color=result[i]
        }*/
    }
    func reset(){
        record=Array(repeating: Array(repeating: rec(), count: maxlen), count: guess)
        keyboard_color=Array(repeating: Array(repeating: 0, count: 4), count: 10)
        let idx=Int.random(in: 0..<Int(data[maxlen].count))
        ans_zu = data[maxlen][idx]
        ans_ch = data_ans[maxlen][idx]
        len=0
        guess_now=0
    }
    var body: some View {
        if change_page == 1{
            shareView(record: $record,change:$change_page,title:$alertTitle)
        }
        else{
            ZStack{
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack{
                    Text(title).font(.largeTitle)//.position(x: 170, y: 0)
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
                                let fileUrl = Bundle.main.url(forResource: "bgm", withExtension: "mp3")!
                                let playerItem = AVPlayerItem(url: fileUrl)
                                self.player.replaceCurrentItem(with: playerItem)
                                    self.player.play()
                            }
                        }
                    HStack(spacing:10){
                        HStack(spacing:3){
                            Text("單字長度:")
                            Button{
                                maxlen = max(maxlen-1,2)
                                reset()
                            }label:{
                                Text("-")
                            }
                            Text("\(maxlen)")
                            Button{
                                maxlen = min(maxlen+1,10)
                                reset()
                            }label:{
                                Text("+")
                            }
                        }
                        HStack(spacing:3){
                            Text("猜題次數:")
                            Button{
                                guess = max(guess-1,3)
                                reset()
                            }label:{
                                Text("-")
                            }
                            Text("\(guess)")
                            Button{
                                guess = min(guess+1,10)
                                reset()
                            }label:{
                                Text("+")
                            }
                        }
                        Button{
                            change_page = 1
                        }label:{
                            if game_end == 1{
                                Text("Share")
                            }
                        }
                    }
                    VStack(spacing:5){//guesses
                        ForEach (record.indices, id:\.self){ i in
                            HStack(spacing:5){
                                ForEach (record[i].indices,id:\.self){ j in
                                    if record[i][j].color == 0{//init
                                        Rectangle().fill(Color.gray).frame(width: CGFloat(250/maxlen), height: CGFloat(300/guess))
                                            .overlay(Text(record[i][j].word).font(.system(size:CGFloat(min(250/maxlen,300/guess)))))
                                    }
                                    else if record[i][j].color == 1{//correct
                                        Rectangle().fill(correct).frame(width: CGFloat(250/maxlen), height: CGFloat(300/guess))
                                            .overlay(Text(record[i][j].word).font(.system(size:CGFloat(min(250/maxlen,300/guess)))))
                                    }
                                    else if record[i][j].color == 2{//wrong position
                                        Rectangle().fill(wrong_pos).frame(width: CGFloat(250/maxlen), height: CGFloat(300/guess))
                                            .overlay(Text(record[i][j].word).font(.system(size:CGFloat(min(250/maxlen,300/guess)))))
                                    }
                                    else{//wrong
                                        Rectangle().fill(wrong).frame(width: CGFloat(250/maxlen), height: CGFloat(300/guess))
                                            .overlay(Text(record[i][j].word).font(.system(size:CGFloat(min(250/maxlen,300/guess)))))
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
                                        if game_end == 0 && lock == 0{
                                            let idx:String.Index=keyboard[i].index(keyboard[i].startIndex,offsetBy:j)
                                            if keyboard[i][idx...idx] == "⇤"{
                                                if len != 0{
                                                    len-=1
                                                    record[guess_now][len].word=" "
                                                }
                                            }
                                            else if keyboard[i][idx...idx] == "↵"{
                                                if len == maxlen{
                                                    var str:String=""
                                                    for k in(0..<maxlen){
                                                        str += record[guess_now][k].word
                                                    }
                                                    if str==ans_zu{
                                                        judge(win:1)
                                                        warning = true
                                                        title=("answer:"+ans_ch)
                                                        alertTitle = "correct"
                                                        game_end=1
                                                    }
                                                    else{
                                                        if let tmp = data[maxlen].first(where:{$0 == str}){
                                                            if guess_now + 1 == guess{
                                                                judge(win:0)
                                                            }
                                                            else{
                                                                judge(win:1)
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
                                                record[guess_now] = Array(repeating: rec(), count: maxlen)
                                            }
                                            else if len != maxlen{
                                                record[guess_now][len].word = (""+keyboard[i][idx...idx])
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
