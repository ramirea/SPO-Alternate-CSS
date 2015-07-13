# SPO Custom CSS via PowerShell / CSOM
How to deploy custom css to a site collection via the CSOM API.

_Note: this solution does not alter the site masterpage._ 

## Instructions

To implement the solution, you will:

1. Generate the css file
2. Upload the css file to your SiteAssets library
3. Update 'Alternate CSS URL' in Site Features

## 1. Generate the CSS file
You can either use the default theme or create a child theme. To create a child theme, you'll use [Sass](http://sass-lang.com/). Make sure to download a Sass compiler, such as [Koala](http://koala-app.com/).

### Default Theme
To install the default theme, skip to [Step 3](#3-update-alternate-css-url-in-site-features).

### Custom Child Theme
View sample child themes by opening any of the `sample.*.scss` files. 

To create a simple green child theme, create a new file and include the following:
```Sass
// Green Theme
// -----------

// Insert custom variables here. Can be a separate file or inline scss
$theme-primary: #019864;


// Import theme files

@import 'cos.variables';
@import 'cos.mixins';
@import 'cos.theme';

// Insert additional custom css below this line
```
You can overwrite any of the variables contained in [cos.variables.scss](scss/cos.variables.scss).

Once the custom theme is done, compile the Sass file using a Sass compiler, such as [Koala](http://koala-app.com/). Most compilers can be configured to auto-compile every time the file is updated (saved).

## 2. Upload CSS to your SIteAssets library
The default Site Assets library is usually located at `/sites/sitecollection/SiteAssets/`

1. Open up SiteAssets
2. Create a folder titled "css"
3. Upload your `.css` file to `/SiteAssets/css/`

## 3. Update 'Alternate CSS URL' in Site Features

*Note: this step requires enabling the "SharePoint Server Publishing" feature in *Manage site features* under *Site Actions*. 

You can update the <code>Alternate CSS URL</code> value on your site collection or subsite by going to <code>Site Settings > Look and Feel > Master page > Alternate CSS Url</code>.

Optional: Reset all subsites to inherit this alternate CSS URL.

Click OK, and you're done. 