using System;
using System.Collections.Generic;
using Foundation;
using MapKit;
using Naxam.iOS.PlacePicker;
using UIKit;

namespace DemoBindingNXPlacePicker
{
	public partial class ViewController : UIViewController, INXPlacePickerDelegate
	{
		protected ViewController(IntPtr handle) : base(handle)
		{
			// Note: this .ctor should not contain any initialization logic.
		}

		public override void ViewDidLoad()
		{
			base.ViewDidLoad();
			// Perform any additional setup after loading the view, typically from a nib.

            btnSelectPlace.TouchUpInside += delegate {
				NXPlacePickerViewController vc = NXPlacePickerViewController.InitWithDelegate(this);
				this.PresentViewController(vc, true, null);
            };
		}

		public override void ViewDidAppear(bool animated)
		{
			base.ViewDidAppear(animated);
		}

		public override void DidReceiveMemoryWarning()
		{
			base.DidReceiveMemoryWarning();
			// Release any cached data, images, etc that aren't in use.
		}

		// INXPlacePickerDelegate
		public void DidSelectPlace(NXPlacePickerViewController viewController, MKPlacemark place)
		{
            viewController.DismissViewController(true, null);
            var addressLines = place.AddressDictionary["FormattedAddressLines"] as NSArray;
            lblSelectedPlace.Text = string.Join(", ", (IEnumerable<NSString>)NSArray.FromArray<NSString>(addressLines));
			//throw new NotImplementedException();
		}
	}
}
