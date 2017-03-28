using System;

using UIKit;
using Foundation;
using ObjCRuntime;
using CoreGraphics;
using MapKit;

namespace NXPlacePicker
{
	// The first step to creating a binding is to add your native library ("libNativeLibrary.a")
	// to the project by right-clicking (or Control-clicking) the folder containing this source
	// file and clicking "Add files..." and then simply select the native library (or libraries)
	// that you want to bind.
	//
	// When you do that, you'll notice that MonoDevelop generates a code-behind file for each
	// native library which will contain a [LinkWith] attribute. MonoDevelop auto-detects the
	// architectures that the native library supports and fills in that information for you,
	// however, it cannot auto-detect any Frameworks or other system libraries that the
	// native library may depend on, so you'll need to fill in that information yourself.
	//
	// Once you've done that, you're ready to move on to binding the API...
	//
	//
	// Here is where you'd define your API definition for the native Objective-C library.
	//
	// For example, to bind the following Objective-C class:
	//
	//     @interface Widget : NSObject {
	//     }
	//
	// The C# binding would look like this:
	//
	//     [BaseType (typeof (NSObject))]
	//     interface Widget {
	//     }
	//
	// To bind Objective-C properties, such as:
	//
	//     @property (nonatomic, readwrite, assign) CGPoint center;
	//
	// You would add a property definition in the C# interface like so:
	//
	//     [Export ("center")]
	//     CGPoint Center { get; set; }
	//
	// To bind an Objective-C method, such as:
	//
	//     -(void) doSomething:(NSObject *)object atIndex:(NSInteger)index;
	//
	// You would add a method definition to the C# interface like so:
	//
	//     [Export ("doSomething:atIndex:")]
	//     void DoSomething (NSObject object, int index);
	//
	// Objective-C "constructors" such as:
	//
	//     -(id)initWithElmo:(ElmoMuppet *)elmo;
	//
	// Can be bound as:
	//
	//     [Export ("initWithElmo:")]
	//     IntPtr Constructor (ElmoMuppet elmo);
	//
	// For more information, see http://developer.xamarin.com/guides/ios/advanced_topics/binding_objective-c/
	//

	// @protocol NXPlacePickerDelegate <NSObject>
	[Protocol, Model]
	[BaseType(typeof(NSObject))]
	interface NXPlacePickerDelegate
	{
		// @required -(void)placePicker:(NXPlacePickerViewController *)viewController didSelectPlace:(MKPlacemark *)place;
		[Abstract]
		[Export("placePicker:didSelectPlace:")]
		void DidSelectPlace(NXPlacePickerViewController viewController, MKPlacemark place);
	}

	// @interface NXPlacePickerViewController : UIViewController <MKMapViewDelegate>
	[BaseType(typeof(UIViewController))]
	interface NXPlacePickerViewController : IMKMapViewDelegate
	{
		[Wrap("WeakDelegate")]
		NSObject Delegate { get; set; }

		// @property (weak) id<NXPlacePickerDelegate> delegate;
		[NullAllowed, Export("delegate", ArgumentSemantic.Weak)]
		NSObject WeakDelegate { get; set; }

		// +(instancetype)initWithDelegate:(id<NXPlacePickerDelegate>)delegate;
		[Static]
		[Export("initWithDelegate:")]
		NXPlacePickerViewController InitWithDelegate(INXPlacePickerDelegate @delegate);
	}

	public partial interface INXPlacePickerDelegate : INativeObject { }
}
