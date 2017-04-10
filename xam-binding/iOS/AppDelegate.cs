/*
Copyright 2017 NAXAM

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

using System.Threading.Tasks;
using Foundation;
using UIKit;
using Acr.Support.iOS;
using Naxam.iOS.PlacePicker;
using MapKit;

namespace XfDemo.iOS
{
	[Register("AppDelegate")]
	public partial class AppDelegate : global::Xamarin.Forms.Platform.iOS.FormsApplicationDelegate
	{
		public override bool FinishedLaunching(UIApplication app, NSDictionary options)
		{
			global::Xamarin.Forms.Forms.Init();

			Xamarin.Forms.DependencyService.Register<IPlacePicker, PlatformPlacePicker>();

			LoadApplication(new App());

			return base.FinishedLaunching(app, options);
		}
	}

	public class PlatformPlacePicker : NSObject, IPlacePicker, INXPlacePickerDelegate
	{
		TaskCompletionSource<Place> pickPlaceTaskSource;

		public void DidSelectPlace(NXPlacePickerViewController viewController, MKPlacemark place)
		{
			viewController.DismissViewController(true, null);
			pickPlaceTaskSource?.TrySetResult(new Place
			{
				Name = place.Name
			});
		}

		public Task<Place> PickAsync()
		{
			pickPlaceTaskSource?.TrySetCanceled();
			pickPlaceTaskSource = new TaskCompletionSource<Place>();

			var topVc = UIApplication.SharedApplication.GetTopViewController();
			var vc = NXPlacePickerViewController.InitWithDelegate(this);
			topVc.PresentViewController(vc, true, null);

			return pickPlaceTaskSource.Task;
		}
	}
}
