# SwiftyTextSearch

SwiftyTextSearch Pre-processes the keyword strings to make searching faster.

<li> Create a SwiftyText Object <br>
var newObj = SwiftyText()
OR
var newObj = SwiftyText(["Array"]) <br>
 <br>
<li> Search <br>
newObj.searchText(searchString: "mobil") <br>
 <br>
<li> Delete <br>
newObj.delete(titles: Set(["xyz Mobiles"])) <br>
 <br>
<li> Add <br>
newObj.appendStrings(arr: ["xyz Mobiles"]) <br>
 <br>
<li> Archive <br>
(NSKeyedArchiver.archivedData(withRootObject: newObj) as NSData) <br>
 <br>

<h1>Installation</h1>

<li>Using CocoaPods:</li><br>

<pre>
platform :ios, '8.0'
use_frameworks!
pod 'SwiftyTextSearch', :git => 'https://github.com/sheshans/SwiftyTextSearch.git', :tag => '1.0.0'
</pre>
