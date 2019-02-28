//
//  BlogChunkData.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/2/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import ObjectMapper

enum BCType {
    case quote
    case bodyText
    case bodyImage
    case headerImage
    case details
    case sectionTitle
}

class BCData: Mappable {

    var chunkType: String?
    
    var quoteData: BCQuote?
    var headerData: BCHeaderImage?
    var bodyImageData: BCBodyImage?
    var bodyTextData: BCBodyText?
    var detailsData: BCDetails?
    var sectionTitleData: BCSectionTitle?
    var type: BCType
    
    required init?(map: Map) {
        guard let chunkType = map.JSON["type"] as? String else {
            type = .details
            return
        }
        
        switch chunkType {
        case "text":
            type = .bodyText
        case "quote":
            type = .quote
        case "image":
            type = .bodyImage
        case "header":
            type = .headerImage
        case "details":
            type = .details
        case "section":
            type = .sectionTitle
        default:
            type = .bodyText
        }
    }
    
    func mapping(map: Map) {
        chunkType <- map["type"]
        
        switch type {
        case .quote:
            quoteData <- map["data"]
            
        case .bodyText:
            bodyTextData <- map["data"]
            
        case .headerImage:
            headerData <- map["data"]

        case .bodyImage:
            bodyImageData <- map["data"]
            
        case .details:
            detailsData <- map["data"]

        case .sectionTitle:
            sectionTitleData <- map["data"]
        }
    }
    
}
