

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import "AdSdkToolBar.h"

@interface AdSdkInterstitialPlayerViewController : UIViewController

@property (nonatomic, strong) NSString *adInterstitialOrientation;

- (void)hideStatusBar;

@end
