//
//  ElapsedTime.swift
//  WordBreaker
//
//  Created by danielringskog on 7/21/26.
//

import SwiftUI

struct ElapsedTime: View {
    
    let startTime : Date? //start of current attempts
    let endTime : Date?
    let elapsedTime : TimeInterval
    
    var format: SystemFormatStyle.DateOffset { //go back further in time than current startTime to add in previously  elapsed Time
            .offset(to: startTime! - elapsedTime, allowedFields: [.minute, .second])
        }
    
    var body: some View {
        if let startTime {
            if let endTime {
                Text(endTime, format:format)
            } else {
                Text(TimeDataSource<Date>.currentDate, format:format)
            }
        } else {
            Image(systemName:"pause")
        }
                
    }
}
    


//#Preview {
//    ElapsedTime()
//}
