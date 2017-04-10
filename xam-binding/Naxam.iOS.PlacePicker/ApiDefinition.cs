/*
Copyright 2017 NAXAM

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

using UIKit;
using Foundation;
using ObjCRuntime;
using MapKit;

namespace Naxam.iOS.PlacePicker
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
	/// <summary>
	/// Delegate for NXPlacePickerViewController
	/// </summary>
	[Protocol, Model]
	[BaseType(typeof(NSObject))]
	interface NXPlacePickerDelegate
	{
		// @required -(void)placePicker:(NXPlacePickerViewController *)viewController didSelectPlace:(MKPlacemark *)place;
		/// <summary>
		/// To be called when a place is picked
		/// </summary>
		/// <param name="viewController">View controller.</param>
		/// <param name="place">Place.</param>
		[Abstract]
		[Export("placePicker:didSelectPlace:")]
		void DidSelectPlace(NXPlacePickerViewController viewController, MKPlacemark place);
	}

	// @interface NXPlacePickerViewController : UIViewController <MKMapViewDelegate>
	/// <summary>
	/// A view controller for user to select a place, start searching for a place.
	/// </summary>
	[BaseType(typeof(UIViewController))]
	interface NXPlacePickerViewController : IMKMapViewDelegate
	{
		/// <summary>
		/// NXPlacePickerDelegate
		/// </summary>
		/// <value>The delegate.</value>
		[NullAllowed, Wrap("WeakDelegate")]
		NSObject Delegate { get; set; }

		// @property (weak) id<NXPlacePickerDelegate> delegate;
		/// <summary>
		/// Weak Delegate for NXPlacePickerDelegate
		/// </summary>
		/// <value>The delegate.</value>
		[NullAllowed, Export("delegate", ArgumentSemantic.Weak)]
		NSObject WeakDelegate { get; set; }

		// +(instancetype)initWithDelegate:(id<NXPlacePickerDelegate>)delegate;
		/// <summary>
		/// Create a new instance of NXPlacePickerViewController
		/// </summary>
		/// <returns>The with delegate.</returns>
		/// <param name="delegate">Delegate.</param>
		[Static]
		[Export("initWithDelegate:")]
		NXPlacePickerViewController InitWithDelegate([NullAllowed] INXPlacePickerDelegate @delegate);
	}

	public partial interface INXPlacePickerDelegate : INativeObject { }
}
