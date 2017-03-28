using System;
using MapKit;
using NXPlacePicker;
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
		}

		public override void ViewDidAppear(bool animated)
		{
			base.ViewDidAppear(animated);

			NXPlacePickerViewController vc = NXPlacePickerViewController.InitWithDelegate(this);
			this.PresentViewController(vc, true, null);
		}

		public override void DidReceiveMemoryWarning()
		{
			base.DidReceiveMemoryWarning();
			// Release any cached data, images, etc that aren't in use.
		}

		// INXPlacePickerDelegate
		public void DidSelectPlace(NXPlacePickerViewController viewController, MKPlacemark place)
		{
			//throw new NotImplementedException();
		}
	}
}
