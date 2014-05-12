//
//  SMAnnotationView.m
//  SystemyMobilne
//
//  Created by Adam on 09.05.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMAnnotationView.h"
#import "SMAnnotation.h"

@implementation SMAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
    }
    return self;
}

-(BOOL)isDraggable
{
    SMAnnotation *anno =(SMAnnotation*) self.annotation;
    
    return anno.locationsArray.count >1 ? NO : YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
