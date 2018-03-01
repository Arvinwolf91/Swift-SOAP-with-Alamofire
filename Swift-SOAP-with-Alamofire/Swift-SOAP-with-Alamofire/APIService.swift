//
//  APIService.swift
//  Swift-SOAP-with-Alamofire
//
//  Created by Arvin Sanmuga Rajah on 01/03/2018.
//  Copyright © 2018 biz.blastar. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import StringExtensionHTML
import AEXML

struct Country {
    var name:String = ""
}

class APIService {
    
    class func getCountries(completion: @escaping (_ result: [Country]) -> Void) -> Void {
        
        var countries = [Country]()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = ["xmlns:SOAP-ENV" : "http://schemas.xmlsoap.org/soap/envelope/",
                                  "xmlns:ns1" : "http://www.webserviceX.NET"]
        let envelope = soapRequest.addChild(name: "SOAP-ENV:Envelope", attributes: envelopeAttributes)
        let body = envelope.addChild(name: "SOAP-ENV:Body")
        body.addChild(name: "ns1:GetCountries")
        
        let soapLength = String(soapRequest.xml.count)
        let requestURL = URL(string:  "http://www.webservicex.net/country.asmx")
        
        var mutableR = URLRequest(url:  requestURL!)
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLength, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        
        Alamofire.request(mutableR)
            .responseString { response in
                if let xmlString = response.result.value {
                    let xml = SWXMLHash.parse(xmlString)
                    let body =  xml["soap:Envelope"]["soap:Body"]
                    if let countriesElement = body["GetCountriesResponse"]["GetCountriesResult"].element {
                        let getCountriesResult = countriesElement.text
                        let xmlInner = SWXMLHash.parse(getCountriesResult.stringByDecodingHTMLEntities)
                        for element in xmlInner["NewDataSet"]["Table"].all {
                            if let nameElement = element["Name"].element {
                                var country = Country()
                                country.name = nameElement.text
                                countries.append(country)
                            }
                        }
                    }
                    completion(countries)
                }else{
                    print("error fetching XML")
                }
        }
    }
}
