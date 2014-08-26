//
//  SMAnnotationView.m
//  SystemyMobilne
//
//  Created by Adam on 09.05.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMAnnotationView.h"


@implementation SMAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
    }
    return self;
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.animatesDrop = YES;
        self.canShowCallout = YES;
        [self setPinColorForAnnotation:annotation];
    }
    return self;
}

-(BOOL)isDraggable
{
    SMAnnotation *anno =(SMAnnotation*) self.annotation;
    
    return anno.locationsArray.count >1 ? NO : YES;
}

- (void)setPinColorForAnnotation:(SMAnnotation *)annotation
{
    if([(SMAnnotation*)annotation locationsArray].count >1)
    {
        self.pinColor = MKPinAnnotationColorGreen;
    }
    else
    {
        self.pinColor = MKPinAnnotationColorPurple;
    }
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
