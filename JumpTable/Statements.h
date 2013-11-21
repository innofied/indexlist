//
//  Statements.h
//  JumpTable
//
//  Created by Sandip Saha on 15/11/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Statements : NSObject

@property (strong , nonatomic) NSMutableArray *statement;  //an array to store the statements

-(NSMutableArray *)initializeStatements;  //function to initialize statements

@end
