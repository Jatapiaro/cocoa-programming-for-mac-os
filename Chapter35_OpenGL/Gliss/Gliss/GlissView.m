//
//  GlissView.m
//  Gliss
//
//  Created by Jacobo Tapia on 6/1/21.
//

#import "GlissView.h"
#import <GLUT/glut.h>

typedef NS_ENUM(NSUInteger, SliderType) {
    SliderTypeLight  = 1,
    SliderTypeTetha  = 2,
    SliderTypeRadius = 3
};

@interface GlissView ()
@property (nonatomic, weak) IBOutlet NSSlider *sliderA;
@property (nonatomic, weak) IBOutlet NSSlider *sliderB;
@property (nonatomic, weak) IBOutlet NSSlider *sliderC;
@end

@implementation GlissView {
    float _light, _theta, _radius;
    int _displayList;
}

- (void)awakeFromNib
{
    [self changeParameter:nil];
}

- (void)prepareOpenGL
{
    // The GL context must be active for this functoons to have an effect
    NSOpenGLContext *glContext = self.openGLContext;
    [glContext makeCurrentContext];
    
    // Configure the view
    glShadeModel(GL_SMOOTH);
    glEnable(GL_LIGHTING);
    glEnable(GL_DEPTH_TEST);
    
    // Add some ambient lighting
    GLfloat ambient[] = {0.2, 0.2, 0.2, 1.0};
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient);
    
    // Initialize the light
    GLfloat diffuse[] = {1.0, 1.0, 1.0, 1.0};
    glLightModelfv(GL_LIGHT0, diffuse);
    // And switch it on
    glEnable(GL_LIGHT0);
    
    // Set the properties of the material under ambient light
    GLfloat mat[] = {0.1, 0.1, 0.7, 1.0};
    glMaterialfv(GL_FRONT, GL_AMBIENT, mat);
    
    // Set the properties of the material under diffuse light
    glMaterialfv(GL_FRONT, GL_DIFFUSE, mat);
}

// Called when the view resizes
- (void)reshape
{
    // Convert up to window space, which is in pixel units
    NSRect baseRect = [self convertRectToBase:self.bounds];
    // Now the result is glViewPort() compatible
    glViewport(0, 0, NSWidth(baseRect), NSHeight(baseRect));
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60.0, NSWidth(baseRect) / NSHeight(baseRect), 0.2, 7);
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Clear the background
    glClearColor(0.2, 0.4, 0.1, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Set the view point
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(_radius * sin(_theta), 0, _radius * cos(_theta), 0, 0, 0, 0, 1, 0);
    
    // Put the light in place
    GLfloat lightPosition[] = {_light, 1, 3, 0.0};
    glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);
    
    if (_displayList) {
        glCallList(_displayList);
        //Flush to screen
        glFinish();
        return;
    }
    
    _displayList = glGenLists(1);
    glNewList(_displayList, GL_COMPILE_AND_EXECUTE);
    
    // Draw the stuff
    glTranslatef(0, 0, 0);
    glutSolidTorus(0.3, 0.9, 35, 31);
    glTranslatef(0.0, 0, -1.2);
    glutSolidCone(1, 1, 17, 17);
    glTranslatef(0, 0, 0.6);
    glutSolidTorus(0.3, 1.8, 35, 31);
    
    glEndList();
    glFinish();
}

- (IBAction)changeParameter:(NSSlider *)sender
{
    _light = _sliderA.floatValue;
    _theta = _sliderB.floatValue;
    _radius = _sliderC.floatValue;
    
    self.needsDisplay = YES;
}

@end
