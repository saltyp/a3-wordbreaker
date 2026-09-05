//
//  ElapsedTime.swift
//  WordBreaker
//
//  Created by danielringskog on 7/21/26.
//

import SwiftUI

struct ElapsedTime: View {
    
    let startTime : Date? //start of *current* attempts (even if coming back to this game)
    let endTime : Date?
    let elapsedTime : TimeInterval
    
    var format: SystemFormatStyle.DateOffset { //go back further in time than current startTime to add in previously  elapsed Time
            .offset(to: startTime! - elapsedTime, allowedFields: [.minute, .second])
        }
    
    var body: some View {
        if startTime != nil { //game is being played
            if let endTime {
                Text(endTime, format:format)
            } else {
                Text(TimeDataSource<Date>.currentDate, format:format)
            }
        } else {  //game is not being played
            HStack {
                Image(systemName:"pause")
                Text(Duration.seconds(elapsedTime), format: .time(pattern: .minuteSecond))
            }
        }
                
    }
}

