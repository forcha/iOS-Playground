//
//  ViewController.m
//  FontPicker
//
//  Created by Ariel Cardieri on 23/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UISlider *textSizeSlider;

@property (weak, nonatomic) IBOutlet UISlider *textAlphaSlider;

@property (weak, nonatomic) IBOutlet UILabel *fontNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeSilderTopConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fontNameLabelTopConstraint;

@property (weak, nonatomic) IBOutlet UIPickerView * fontPicker;

@property (strong, nonatomic) NSString * seletedFontFamily;

@property (strong, nonatomic) NSLayoutConstraint * fontNameLabelCenterYConstraint;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    for (NSString* s in [UIFont familyNames]) {
//        NSLog(@"%@: %@", s, [UIFont fontNamesForFamilyName:s]);
//    }
    
    self.seletedFontFamily = [UIFont familyNames][0];

//    _textLabel.layer.borderColor = [UIColor blackColor].CGColor;
//    _textLabel.layer.borderWidth = 1.0;

    _fontPicker.alpha = 0.0;
    [self p_updateFontNameLabel];
    
    self.fontNameLabelCenterYConstraint = [NSLayoutConstraint
                                  constraintWithItem:_fontNameLabel
                                           attribute:NSLayoutAttributeCenterY
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:_fontNameLabel.superview
                                           attribute:NSLayoutAttributeCenterY
                                          multiplier:1
                                            constant:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)textSizeChanged:(id)sender {
    [self p_updateText];
}

- (IBAction)textAlphaChanged:(id)sender {
    [self p_updateText];
}

- (IBAction)tapFontNameLabel:(UITapGestureRecognizer *)sender {
    _textFieldTopConstraint.constant = _textFieldTopConstraint.constant - 43;
    [_fontNameLabel.superview removeConstraint:_fontNameLabelTopConstraint];
    [_fontNameLabel.superview addConstraint:_fontNameLabelCenterYConstraint];
    _sizeSilderTopConstraint.constant = _sizeSilderTopConstraint.constant + 88;
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_fontNameLabel.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _fontPicker.alpha = 1.0;
        } completion:^(BOOL finished) {
            _fontNameLabel.hidden = YES;
        }];
    }];
}

- (IBAction)tapFontPicker:(UITapGestureRecognizer *)sender {
    [self p_updateFontNameLabel];
    [_fontNameLabel layoutIfNeeded];
    _fontNameLabel.hidden = NO;

    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _fontPicker.alpha = 0.0;
    } completion:^(BOOL finished) {
        _textFieldTopConstraint.constant = _textFieldTopConstraint.constant + 43;
        _sizeSilderTopConstraint.constant = _sizeSilderTopConstraint.constant - 88;
        [_fontNameLabel.superview removeConstraint:_fontNameLabelCenterYConstraint];
        [_fontNameLabel.superview addConstraint:_fontNameLabelTopConstraint];
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_fontNameLabel.superview layoutIfNeeded];
        } completion:^(BOOL finished) {

        }];
    }];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [UIFont familyNames].count;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* lab;
    if (view) {
        lab = (UILabel*)view; // reuse it
    } else {
        lab = [UILabel new];
    }

    NSString * fontFamilyName = [UIFont familyNames][row];
    NSArray * fonts = [UIFont fontNamesForFamilyName:fontFamilyName];
    lab.text = fontFamilyName;
    lab.font = [UIFont fontWithName:[fonts firstObject] size:35.0f];
    lab.backgroundColor = [UIColor clearColor];
    [lab sizeToFit];
    return lab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.seletedFontFamily = [UIFont familyNames][row];
    [self p_updateText];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.textField) {
        self.textLabel.text = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textField) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Private

- (void)p_updateText {
    self.textLabel.text = self.textField.text;
    self.textLabel.alpha = _textAlphaSlider.value;
    NSArray * fonts = [UIFont fontNamesForFamilyName:self.seletedFontFamily];
    self.textLabel.font = [UIFont fontWithName:[fonts firstObject] size:self.textSizeSlider.value];
    
}

- (void)p_updateFontNameLabel {
    NSArray * fonts = [UIFont fontNamesForFamilyName:self.seletedFontFamily];
    _fontNameLabel.text = self.seletedFontFamily;
    _fontNameLabel.font = [UIFont fontWithName:[fonts firstObject] size:35.0f];
    [_fontNameLabel sizeToFit];
}

@end
