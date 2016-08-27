//
//  AppDelegate.swift
//  Prototype
//
//  Created by Anthony Parente on 8/2/16.
//  Copyright © 2016 Anthony Parente. All rights reserved.
//

///////////////////////////
//the fuck is a git
/////////////////////////// 8/27 3:00PM
import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {

    /*func applicationDidFinishLaunching(application: UIApplication) {
        if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce") == false){
            // app already launched
        }
        else{
            // This is the first launch ever
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }*/
    
    var window: UIWindow?
    
    let audioPhoneURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("audio", ofType: "wav")!)
    let masterArrayFile = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("arrayFile", ofType: "txt")!)
    let username = "b3589c1b-72dd-41ad-8ae1-87c9e57188df"
    let password = "SO2oZ4GRZC0R"
    var speechToTextData: NSData!
    var sessionID: String!
    var sessionIDdata: NSData!
    var kookie: String!
    var stringToBeParsed: String! =  "Hi, what is your name?  My name is Johnny, and yiurs is? I'm Patrick Hoover of Hoover Construction Group.  So you work in construction?  Well, no, not really.  I manage the company's finances.  Oh, that makes sense!  I too work in finance for BlockChain Corp.  Funny that we would end up at a tech event in NYC together.  So why come to an artificial intelligence event?  I would like to know whether or not these technologies could take our jobs.  There is no way.  A human eye must be available to check for errors.  Humans make errors, robots don't.  I guess we must see.  I don't think we would want to have a computer manage our entire financial system.  We will lose all control.  Those are valid points.  Well, let's listen to this talk, he is head of artificial intelligence at Facebook."/*"Nice pair of pants you've got there.  Oh, thank you.  Bought them from H and M.  What's your name?  Oh, I'm Johnny, you?  Willy; what brings you here?  My company had asked me to come in, we need new clients.  You work in sales?  Something like that.  I'm the key networker for BlockChain corp.  Interesting, how did you get that job.  Well, I had always gone to a ton of meetups during my time at Flat University, and so I picked up a knack for it, applied and got the job.  What do you do?  I'm a financial consultant at PWC.  So what makes you come to a tech event? I am interested in changing my career path.  I know that I am able to code, I really want to learn to feel as though I am contributing to something important.  Wow, I wish I had desires like that.  I am just content with what I am doing now.  How do you expect to learn coding?  There are a ton of online courses; I already took a few intro courses during my time at Rutgers.  Would you do a startup thing or try to get a corporate programming job?  I don't know, I guess I will see.  Well, it seems as though the key note is about to begin. Let's connect on LinkedIn or Facebook. Sure!"*//*"Hi my name is Trevor, what is yours?  Oh, I am Johnny Rocket.  What brings you here, Trevor?  I am very interested in robotics and how humans can leverage this technology to make the world a better place.  Oh wow! Where do you work, Trevor?  I actually am only a student at Baruch College.  What about you?  I am unemployed, but I am working on writing a sci-fi book, and that is what has brought me here today."*/
    var encodedString: String!
    var alchemyData: NSData!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        WCSession.defaultSession().delegate = self
        WCSession.defaultSession().activateSession()
        
        return true
    }
    
    // MARK: - Connectivity
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print("Received Application Context")
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        let m = message["message"] as! String
        print("Received Message: \(m)")
    }
    
    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
        
        print("Received File with URL: \(file.fileURL)")
        
        let data = NSData(contentsOfURL: file.fileURL)
        data!.writeToURL(self.audioPhoneURL, atomically: false)
        
        self.callWatson()
        
    }
    func callWatson(){
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        let watsonURL = NSURL(string:"https://stream.watsonplatform.net/speech-to-text/api/v1/sessions")!
        
        let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
        conf.HTTPShouldSetCookies = true
        conf.HTTPShouldUsePipelining = true
        conf.HTTPMaximumConnectionsPerHost = 4
        let session = NSURLSession(configuration: conf, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let request = NSMutableURLRequest(URL: watsonURL)
        request.HTTPMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let connection = session.dataTaskWithRequest(request, completionHandler: {(data, res, error) in
            guard let _: NSData = data, let _:NSURLResponse = res  where error == nil else {
                print(error)
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
            self.sessionIDdata = data!
            self.showCookies()
            print("The session cookie is: \(self.kookie)")
            self.sessionIDLocator()
            self.postRequest()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.getRequest()
                
            })
            //  self.deleteCookies()
            
        })
        connection.resume()
        
    }
    
    func sessionIDLocator(){
        var json: NSDictionary
        do {
            json = try NSJSONSerialization.JSONObjectWithData(self.sessionIDdata, options: NSJSONReadingOptions()) as! NSDictionary
            self.sessionID = json["session_id"] as! String
            print("session id = \(self.sessionID)")
        } catch {
            print(error)
        }
    }
    
    func postRequest() {
        print("sending")
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        let firstPart = "https://stream.watsonplatform.net/speech-to-text/api/v1/sessions/"
        let secondPart = self.sessionID
        let thirdPart1 = "/recognize?continuous=true"
        let postURL = firstPart + secondPart + thirdPart1
        
        let postRequestURL = NSURL(string:postURL)!
        
        let conf1 = NSURLSessionConfiguration.defaultSessionConfiguration()
        conf1.HTTPShouldSetCookies = true
        conf1.HTTPShouldUsePipelining = true
        conf1.timeoutIntervalForRequest = 600
        conf1.HTTPMaximumConnectionsPerHost = 4
        let session1 = NSURLSession(configuration: conf1, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        let request1 = NSMutableURLRequest(URL: postRequestURL)
        request1.HTTPMethod = "POST"
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request1.setValue("audio/wav", forHTTPHeaderField: "content-type")
        //request1.setValue("chunked", forHTTPHeaderField: "transfer-encoding")
        request1.setValue("SESSIONID=\(self.kookie))", forHTTPHeaderField: "Cookie")
        //request.setValue("false", forHTTPHeaderField: "profanity_filter")
        //let urlData = NSData(contentsOfURL: self.audioURL)
        
        let task = session1.uploadTaskWithRequest(request1, fromFile: self.audioPhoneURL, completionHandler: { (data, res, error) in
            if( error == nil ){
                print("sent")
            }
            else{
                print(error)
            }
        })
        
        task.resume()
        
    }
    
    func getRequest(){
        print("activated")
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        let firstPart = "https://stream.watsonplatform.net/speech-to-text/api/v1/sessions/"
        let secondPart = self.sessionID
        let thirdPart2 = "/observe_result"/*?interim_results=true"*/
        let getURL = firstPart + secondPart + thirdPart2
        let getRequestURL = NSURL(string:getURL)!
        
        let conf2 = NSURLSessionConfiguration.defaultSessionConfiguration()
        conf2.HTTPShouldSetCookies = true
        conf2.HTTPShouldUsePipelining = true
        conf2.timeoutIntervalForRequest = 600
        conf2.HTTPMaximumConnectionsPerHost = 4
        let session2 = NSURLSession(configuration: conf2, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let request2 = NSMutableURLRequest(URL: getRequestURL)
        request2.HTTPMethod = "GET"
        request2.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request2.setValue("SESSIONID=\(self.kookie))", forHTTPHeaderField: "Cookie")
        
        let connection = session2.dataTaskWithRequest(request2, completionHandler: {(data, res, error) in
            guard let _: NSData = data, let _:NSURLResponse = res  where error == nil else {
                print(error)
                return
            }
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("get results = \(dataString)")
            self.speechToTextData = data!
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
              //  self.stringToBeParsed = self.jsonRead()
                //self.transcriptFilter()
                self.alchemyWork()
            })
        })
        
        connection.resume()
        
    }
    
    func alchemyWork(){
        self.encodedString = self.stringToBeParsed.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())
        let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: conf, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        let alchemyURL = "http://gateway-a.watsonplatform.net/calls/text/TextGetCombinedData?apikey=967568f1853432f6911f738cafbad34617168c69&outputMode=json&extract=entities,keywords,taxonomy,concepts,relations,doc-sentiment,doc-emotion,typed-rels,authors"
        let textString = "&text=" + self.encodedString
        let concatenatedURL = alchemyURL + textString
        let request = NSMutableURLRequest(URL: NSURL(string: concatenatedURL)!)
        
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        
        
        //  let filePath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("file", ofType: "txt")!)
        
        let connection = session.dataTaskWithRequest(request, completionHandler: {(data, res, error) in
            guard let _: NSData = data, let _:NSURLResponse = res  where error == nil else {
                print(error)
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            self.alchemyData = data!
            print(dataString)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let mastArr = self.jsonSorter()
                mastArr.writeToURL( self.masterArrayFile, atomically: false)
               // let file = NSMutableArray(contentsOfURL: self.masterArrayFile)
               // print(file![0][1])
               // dispatch_async(dispatch_get_main_queue(), { () -> Void in
                WCSession.defaultSession().transferFile(self.masterArrayFile, metadata: nil)
               // })
            })
        })
        
        connection.resume()
        
    }
    func transcriptFilter() -> NSMutableArray {
        var arrayWithDictAtZero: NSMutableArray = []
        
        var transcriptArrayDict: Dictionary<String, NSMutableArray> = [:]
        
        var interestSentArr: NSMutableArray = []
        var wantSentArr: NSMutableArray = []
        var likeSentArr: NSMutableArray = []
        
        let stringWithoutQmarks = self.stringToBeParsed.stringByReplacingOccurrencesOfString("?", withString: ".")
        let stringWithOnlyPeriods = stringWithoutQmarks.stringByReplacingOccurrencesOfString("!", withString: ".")
        
        let options: NSLinguisticTaggerOptions = [.OmitWhitespace, .OmitPunctuation, .JoinNames]
        let schemes = NSLinguisticTagger.availableTagSchemesForLanguage("en")
        let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
        
        var createInterestString: String = ""
        var createWantString: String = ""
        var createILikeString: String = ""
        
        let transcriptArray = stringWithOnlyPeriods.componentsSeparatedByString(".")
        if(transcriptArray.count > 0){
            for(var i = 0; i < transcriptArray.count; i += 1){
                var interest = transcriptArray[i].containsString("interest")
                var want = transcriptArray[i].containsString("want")
                if(interest == true){
                    print(transcriptArray[i])
                    tagger.string = transcriptArray[i]
                    tagger.enumerateTagsInRange(NSMakeRange(0, (transcriptArray[i] as NSString).length), scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: options) { (tag, tokenRange, _, _) in
                        let token = (transcriptArray[i] as NSString).substringWithRange(tokenRange)
                        print("token:\(token) tag:\(tag)")
                        interest = token.containsString("interest")
                        if(interest == true || tag == "Verb" || tag  == "Adverb" || tag == "Noun" || tag == "Preposition"){
                            if(interest == true){
                                createInterestString += " interested"
                            }else if(token == "am"){
                                createInterestString += " is"
                            }else{
                                createInterestString += " \(token)"
                            }
                        }
                    }
                    interestSentArr.addObject(createInterestString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
                    print(interestSentArr)

                }
                
            
                if(want == true){
                    var wantCameUp = false
                    print(transcriptArray[i])
                    tagger.string = transcriptArray[i]
                    tagger.enumerateTagsInRange(NSMakeRange(0, (transcriptArray[i] as NSString).length), scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: options) { (tag, tokenRange, _, _) in
                        let token = (transcriptArray[i] as NSString).substringWithRange(tokenRange)
                        print("token:\(token) tag:\(tag)")
                        want = token.containsString("want")
                        if(want == true || self.loopForWantTranscript(wantCameUp) == true/*|| tag == "Verb" || tag  == "Adverb" || tag == "Noun" || tag == "Preposition"*/){
                            if(token == "am" || tag == "Pronoun"){
                                
                            }else if(want == true){
                                if(transcriptArray[i].containsString("would not") || transcriptArray[i].containsString("does not") || transcriptArray[i].containsString("wouldn't") ||
                                transcriptArray[i].containsString("doesn't") || transcriptArray[i].containsString("don't") ||
                                    transcriptArray[i].containsString("not want")){
                                    createWantString += " doesn't want"
                                    
                                }else{
                                    createWantString += " wants"
                                }
                                wantCameUp = true
                            }else{
                                createWantString += " \(token)"
                            }
                        }
                    }
                    wantSentArr.addObject(createWantString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
                    print(wantSentArr)
                }
            }
            transcriptArrayDict["interestArr"] = interestSentArr
            transcriptArrayDict["wantArr"] = wantSentArr
        }
        arrayWithDictAtZero.addObject(transcriptArrayDict)
        return(arrayWithDictAtZero)
    }
    
    func loopForWantTranscript(bool: Bool) -> Bool{
        var finalTruthVal: Bool
        var x = 5
        if(bool == true){
            x-=1
        }
        if(x <= 4 && x > 0){
            finalTruthVal = true
        }else{
            finalTruthVal = false
        }
        return(finalTruthVal)
    }
    
    func jsonSorter() -> NSMutableArray {
        
        var json: NSDictionary?
        let masterArray: NSMutableArray = []
        
        do{
            json = try NSJSONSerialization.JSONObjectWithData(self.alchemyData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            
            let keywordsRes = json!["keywords"]
            let entitiesRes = json!["entities"]
            let taxonomyRes = json!["taxonomy"]
            let conceptsRes = json!["concepts"]
            let emotionsRes = json!["docEmotions"]
            let typedRelationsRes = json!["typedRelations"]
            
            let kw_MutArray = self.keywordFunc(keywordsRes!)
            let ent_Text_MutArray = self.entityTextFunc(entitiesRes!)
            let ent_Type_MutArray = self.entityTypeFunc(entitiesRes!)
            let tax_MutArray = self.taxonomyFunc(taxonomyRes!)
            let con_MutArray = self.conceptFunc(conceptsRes!)
            let emo_MutArray = self.emotionsFunc(emotionsRes!)
            let occOrg_TR_MutArray = self.occOrg_TR_Func(typedRelationsRes!)
            let occCompany_Entity_MutArray = self.occupationFinderThruEntities_C(entitiesRes!)
            let occJobTitle_Entity_MutArray = self.occupationFinderThruEntities_JT(entitiesRes!)
            let education_MutArray = self.educationInfo(entitiesRes!)
            let eduOcc_TR_MutArray = self.occEdu_TR_Func(typedRelationsRes!)
            let userInfo_MutArray = self.userInfoFunc()
            let interest_MutArr = self.transcriptFilter()
            
           // dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //pos[0]
                masterArray.addObject(kw_MutArray)
                //pos[1]
                masterArray.addObject(ent_Text_MutArray)
                //pos[2]
                masterArray.addObject(ent_Type_MutArray)
                //pos[3]
                masterArray.addObject(tax_MutArray)
                //pos[4]
                masterArray.addObject(con_MutArray)
                //pos[5] only a single emotion sent at 5,0
                masterArray.addObject(emo_MutArray)
                //pos[6]
                masterArray.addObject(occOrg_TR_MutArray)
                //pos[7]
                masterArray.addObject(occCompany_Entity_MutArray)
                //pos[8]
                masterArray.addObject(occJobTitle_Entity_MutArray)
                //pos[9]
                masterArray.addObject(education_MutArray)
                //pos[10]
                masterArray.addObject(eduOcc_TR_MutArray)
                //pos[11]
                masterArray.addObject(userInfo_MutArray)
                //pos[12]
                masterArray.addObject(interest_MutArr)
            
           // })
           
        } catch {
            print(error)
        }
        
        return(masterArray)
    }
    
    func userInfoFunc() -> NSMutableArray{
        var userInfoArray:NSMutableArray = []
        let def = self.defaults
        
        let fName = def.stringForKey("userFirstName")
        let lName = def.stringForKey("userLastName")
        let edu = def.stringForKey("userEducation")
        let company = def.stringForKey("userCompanyName")
        let occ = def.stringForKey("userOccupation")
        
        
        //pos[0]
        userInfoArray.addObject(fName!)
        //pos[1]
        userInfoArray.addObject(lName!)
        //pos[2]
        userInfoArray.addObject(edu!)
        //pos[3]
        userInfoArray.addObject(company!)
        //pos[4]
        userInfoArray.addObject(occ!)
        
        
        print(userInfoArray)
        
        return(userInfoArray)
    }
    
    func keywordFunc(results: AnyObject) -> NSMutableArray {
            
        var keywordDic: Dictionary<Float, String> = [:]
        var keywordContent: NSMutableArray = []
            
        let keywordArr = results as! NSArray
        if keywordArr.count > 0 {
            for(var i = 0; i < keywordArr.count; i += 1){
                let iKeyword = keywordArr[i] as! NSDictionary
                var textVar = iKeyword["text"] as! String
                var relevanceVar = (iKeyword["relevance"] as! NSString).floatValue
                keywordDic[relevanceVar] = textVar
                keywordContent.addObject(textVar)
                    
            }
        }
            
        return(keywordContent)
    }
    
    func entityTextFunc(results: AnyObject) -> NSMutableArray {
        
        //var entityDic: Dictionary<Float, String> = [:]
        var entityContent: NSMutableArray = []
        
        let entitiesArr = results as! NSArray
        if entitiesArr.count > 0 {
            for(var i = 0; i < entitiesArr.count; i += 1){
                let iEntity = entitiesArr[i] as! NSDictionary
                let textVar = iEntity["text"] as! String
               // let relevanceVar = (iEntity["relevance"] as! NSString).floatValue
                let type = iEntity["type"] as! String
                entityContent.addObject(textVar)
            }
        }
        return(entityContent)
    }
    
    func entityTypeFunc(results: AnyObject) -> NSMutableArray {
       var entityContent: NSMutableArray = []
        
        let entitiesArr = results as! NSArray
        if entitiesArr.count > 0 {
            for(var i = 0; i < entitiesArr.count; i += 1){
                let iEntity = entitiesArr[i] as! NSDictionary
                let type = iEntity["type"] as! String
                entityContent.addObject(type)
            }
        }
        return(entityContent)
        
    }
    
    func taxonomyFunc(results: AnyObject) -> NSMutableArray {
        
        var taxonomyDic: Dictionary<Float, String> = [:]
        var taxonomyContent: NSMutableArray = []
        
        let taxonomyArr = results as! NSArray
        if taxonomyArr.count > 0 {
            for(var i = 0; i < taxonomyArr.count; i += 1){
                let iTaxonomy = taxonomyArr[i] as! NSDictionary
                let labelVar = iTaxonomy["label"] as! String
                let scoreVar = (iTaxonomy["score"] as! NSString).floatValue
                taxonomyDic[scoreVar] = labelVar
                taxonomyContent.addObject(labelVar)
            }
        }
        return(taxonomyContent)
    }
    
    func conceptFunc(results: AnyObject) -> NSMutableArray {
        
        var conceptDic: Dictionary<Float, String> = [:]
        var conceptContent: NSMutableArray = []
        
        let conceptArr = results as! NSArray
        if conceptArr.count > 0 {
            for(var i = 0; i < conceptArr.count; i += 1) {
                let iConcept = conceptArr[i] as! NSDictionary
                let textVar = iConcept["text"] as! String
                let relevanceVar = (iConcept["relevance"] as! NSString).floatValue
                conceptDic[relevanceVar] = textVar
                conceptContent.addObject(textVar)
            }
        }
        return(conceptContent)

    }
    
    func emotionsFunc(results: AnyObject) -> NSMutableArray {
        
        var emotionsDic: Dictionary<Float, String> = [:]
        var emotionsContent: NSMutableArray = []
        
        let dictionaryChecker = results as! NSDictionary
        if(dictionaryChecker.count > 0){

            let angerScore = (results["anger"]! as! NSString).floatValue
            let disgustScore = (results["disgust"]! as! NSString).floatValue
            let fearScore = (results["fear"]! as! NSString).floatValue
            let joyScore = (results["joy"]! as! NSString).floatValue
            let sadnessScore = (results["sadness"]! as! NSString).floatValue

            emotionsDic[angerScore] = "anger"
            emotionsDic[disgustScore] = "disgust"
            emotionsDic[fearScore] = "fear"
            emotionsDic[joyScore] = "joy"
            emotionsDic[sadnessScore] = "sadness"
        
            let sortedKeys = Array(emotionsDic.keys).sort(>)
            let relevantScore = sortedKeys.first
        
            let relevantEmotion = emotionsDic[relevantScore!]
        
            emotionsContent.addObject(relevantEmotion!)
        }
        return(emotionsContent)
        
    }
    
    func occOrg_TR_Func(results: AnyObject) -> NSMutableArray{
        var typedRelsMutArray: NSMutableArray = []
        let arrayChecker = results as! NSArray
        if(arrayChecker.count > 0){
        
            let typedRelsArray = results as! NSArray
        
            if(typedRelsArray.count > 0){
                for(var i = 0; i < typedRelsArray.count; i += 1){
                    let iRelation = typedRelsArray[i] as! NSDictionary
                    let relType = iRelation["type"] as! String
                    if(relType == "employedBy"){
                        let argumentsArray = iRelation["arguments"] as! NSArray
                        for(var s = 0; s < argumentsArray.count; s += 1){
                            let sRelation = argumentsArray[s] as! NSDictionary
                            let entityArray = sRelation["entities"] as! NSArray
                            let entDict = entityArray[0] as! NSDictionary
                            let type = entDict["type"] as! String
                            let text = entDict["text"] as! String
                            if(type == "Organization" || type == "Company"){
                                typedRelsMutArray.addObject(text)
                            }
                        }
                    }
                
                }
            }
        }
        print(typedRelsMutArray)
        return(typedRelsMutArray)
    }
    
    func occEdu_TR_Func(results: AnyObject) -> NSMutableArray{
        var typedRelsMutArray: NSMutableArray = []
        let arrayChecker = results as! NSArray
        if(arrayChecker.count > 0){
            
            let typedRelsArray = results as! NSArray
            
            if(typedRelsArray.count > 0){
                for(var i = 0; i < typedRelsArray.count; i += 1){
                    let iRelation = typedRelsArray[i] as! NSDictionary
                    let relType = iRelation["type"] as! String
                    if(relType == "educatedAt"){
                        let argumentsArray = iRelation["arguments"] as! NSArray
                        for(var s = 0; s < argumentsArray.count; s += 1){
                            let sRelation = argumentsArray[s] as! NSDictionary
                            let entityArray = sRelation["entities"] as! NSArray
                            let entDict = entityArray[0] as! NSDictionary
                            let type = entDict["type"] as! String
                            let text = entDict["text"] as! String
                            if(type == "Organization" || type == "Company"){
                                typedRelsMutArray.addObject(text)
                            }
                        }
                    }
                    
                }
            }
        }
        return(typedRelsMutArray)
    }
    
    func occupationFinderThruEntities_C(results: AnyObject) -> NSMutableArray {
        var companyContent: NSMutableArray = []
        
        let entitiesArr = results as! NSArray
        if entitiesArr.count > 0 {
            for(var i = 0; i < entitiesArr.count; i += 1){
                let iEntity = entitiesArr[i] as! NSDictionary
                let type = iEntity["type"] as! String
                let text = iEntity["text"] as! String
                if(type == "Company" && text.lowercaseString != "linkedin" && text.lowercaseString != "facebook" && text.lowercaseString != "google"){
                    companyContent.addObject(text)
                }
            }
        }
        return(companyContent)

    }
    
    func occupationFinderThruEntities_JT(results: AnyObject) -> NSMutableArray {
        var jobTitleContent: NSMutableArray = []
        
        let entitiesArr = results as! NSArray
        if entitiesArr.count > 0 {
            for(var i = 0; i < entitiesArr.count; i += 1){
                let iEntity = entitiesArr[i] as! NSDictionary
                let type = iEntity["type"] as! String
                let text = iEntity["text"] as! String
                if(type == "JobTitle") {
                    jobTitleContent.addObject(text)
                }
            }
        }
        return(jobTitleContent)
    }
    
    func educationInfo(results: AnyObject) -> NSMutableArray {
        var universityInfo: NSMutableArray = []
        let entitiesArr = results as! NSArray
        if entitiesArr.count > 0 {
            for(var i = 0; i < entitiesArr.count; i += 1){
                let iEntity = entitiesArr[i] as! NSDictionary
                let text = iEntity["text"] as! String
                let disambiguated = iEntity["disambiguated"]
                if(disambiguated != nil){
                    let disambiguatedDict = disambiguated as! NSDictionary
                    let subTypeArr = disambiguatedDict["subType"] as! NSArray
                    for(var s = 0; s < subTypeArr.count; s += 1){
                        let curSubType = subTypeArr[s] as! String
                        if(curSubType == "University" || curSubType == "CollegeUniversity"){
                            universityInfo.addObject(text)
                        }

                    }
                }
               
            }
        }
        return(universityInfo)
    }
    
    func jsonRead()-> String {
        var json: NSDictionary
        var text: String = " "
        do {
            json = try NSJSONSerialization.JSONObjectWithData(self.speechToTextData, options: NSJSONReadingOptions()) as! NSDictionary
            let res = json["results"]
            let resArr = res as! NSArray
            if resArr.count > 0 {
                let firstRes = resArr[0] as! NSDictionary
                let alts = firstRes["alternatives"] as! NSArray
                let firstAlt = alts[0] as! NSDictionary
                text = firstAlt["transcript"]! as! String
                //  let confidence = firstAlt["confidence"] as! Float
            } else {
                print("error")
            }
        } catch {
            print(error)
        }
        return(text)
    }
    
    
    func showCookies() {
        
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        let cookies = cookieStorage.cookies!
        //print("Cookies.count: \(cookies.count)")
        for cookie in cookies {
            var cookieProperties = [String: AnyObject]()
            
            cookieProperties[NSHTTPCookieName] = cookie.name
            cookieProperties[NSHTTPCookieValue] = cookie.value
            cookieProperties[NSHTTPCookieDomain] = cookie.domain
            cookieProperties[NSHTTPCookiePath] = cookie.path
            cookieProperties[NSHTTPCookieVersion] = NSNumber(integer: cookie.version)
            cookieProperties[NSHTTPCookieExpires] = cookie.expiresDate
            cookieProperties[NSHTTPCookieSecure] = cookie.secure
            
            self.kookie = cookie.value
            // Setting a Cookie
            if let newCookie = NSHTTPCookie(properties: cookieProperties) {
                // Made a copy of cookie (cookie can't be set)
                //        print("Newcookie: \(newCookie)")
                NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(newCookie)
            }
            //  print("ORGcookie: \(cookie)")
        }
    }
    
    
    func deleteCookies() {
        
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies!
        print("Cookies.count: \(cookies.count)")
        for cookie in cookies {
            print("name: \(cookie.name) value: \(cookie.value)")
            NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
        }
        
        //Create newCookie: You need all properties, because else newCookie will be nil (propertie are then invalid)
        var cookieProperties = [String: AnyObject]()
        cookieProperties[NSHTTPCookieName] = "locale"
        cookieProperties[NSHTTPCookieValue] = "nl_NL"
        cookieProperties[NSHTTPCookieDomain] = "www.digitaallogboek.nl"
        cookieProperties[NSHTTPCookiePath] = "/"
        cookieProperties[NSHTTPCookieVersion] = NSNumber(integer: 0)
        cookieProperties[NSHTTPCookieExpires] = NSDate().dateByAddingTimeInterval(31536000)
        let newCookie = NSHTTPCookie(properties: cookieProperties)
        print("\(newCookie)")
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(newCookie!)
    }
    
    func sessionReachabilityDidChange(session: WCSession) {
        print("Reachability changed")
    }
    
    func sessionWatchStateDidChange(session: WCSession) {
        print("Watch state changed")
    }
    
}
