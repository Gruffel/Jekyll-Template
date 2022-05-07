//prebuilt variables: 
  // nav (navigation data), 
  // navigationWrapper (nav DOM element with anvlink ID), 
  // navigationData (processed navigation.json file)
//prebuilt functions: 
  // convertStringToUrl (turns a string into an acceptable SEO friendly URL according to special characters set up in navigation data)
  // shouldBuildString (returns the full string if the bool is true, otherwise returns an empty string, allows for easy nesting of other strings)
  // buildImageHTML (takes a path and an alt and builds an image using the imgX standards)
  // getNavFromTitle (takes a string title and returns the navigation data that title. returns undefined if there is no result)


var isTopLevel = true;
var backButtonNav = [];
var hamburgerMenuButton = `<button aria-label="Mobile Navigation" id="hamburgerMenu" type="button" name="button" onclick="toggleNav();" class="">
                            <div class="hamburgerBar1"></div> 
                            <div class="hamburgerBar2"></div>
                            <div class="hamburgerBar3"></div>
                          </button>
                          <ul id="topNavParent" class="topNavItems"></ul>`;
var isNavOn = false;
var navigationItemsWrapper;

// triggers on page load, creates the hamburger menu and list parent, then stores the list parent for future use to build the navigation
function initiateHamburgerBuild(){
  navigationWrapper.innerHTML = hamburgerMenuButton;
  navigationItemsWrapper = document.getElementById('topNavParent');
}

// triggers on user interaction with the menu button, initiates the construction of the main navigation
function toggleNav(){
  if(!isNavOn)
  {
    isNavOn = true;
    buildNavigationLevel(nav);
    document.getElementById('hamburgerMenu').setAttribute('class', 'hamburgerAnimation');
    document.getElementById('topNavParent').setAttribute('class', 'topNavItems topNavOpen');
  } 
  else
  {
    isNavOn = false;
    navigationWrapper.innerHTML = hamburgerMenuButton;
    navigationItemsWrapper = document.getElementById('topNavParent');
    document.getElementById('hamburgerMenu').setAttribute('class', '');
    document.getElementById('topNavParent').setAttribute('class', 'topNavItems topNavClosed');
  }
}

// oversees the building of the navigation level to be displayed, new Nav Level is either a string of the title of the nav section, or a nav array
function buildNavigationLevel(newNavLevel){
  isTopLevel = (newNavLevel == nav); // detects if the currently loading navigation the same as the default navigation. If so, it will not include the back button later down the line
  newNavLevel = (typeof newNavLevel != "string")? newNavLevel: getNavFromTitle(newNavLevel).children; // if the data fed into this function a string of a top nav item, feed the section data into it

  newNavLevel = removeNonCriticalNavigation(newNavLevel);
  if(newNavLevel.length == 1){
    buildNavigationLevel(newNavLevel[0].children);
    return;
  }

  var levelHtml = '';
  // loops through the nav data for the given area of focus and builds the individual buttons
  for (let i = 0; i < newNavLevel.length; i++) {
    const navItem = newNavLevel[i];
    levelHtml += buildNavButton(navItem);
  }
  levelHtml += buildBackButton();

  navigationItemsWrapper.innerHTML = levelHtml;
}

// the build navigation button detects data from an individual button data and selects the appropriate button type to build
function buildNavButton(navItem){
  var buttonHTML = "";
  var buttonType = "link";
  var link = navItem.href;
  var isExternal = false;
  var title = "";
  var subItems;
  var classes = (typeof navItem == "object" && navItem['class'] != undefined)? navItem['class']:"";
  // detects if the current button is a section or a page link (plus if the link is external or not)
  if(typeof navItem == 'object'){
    // determine if the nav item, given that it is an object, has subchildren. If it does, label it as a section button, if it doesn't keep the preassigned link layout
    subItems = (navItem['children']);  
    if(subItems != undefined)  buttonType = "section";

    title = navItem['title'];
  }
  if(link != undefined) isExternal = (link.slice(0,3) == "http"); // if the first characters of a link are http, then the link is external and should be labelled as such
  if(title == "") title = navItem; 
  
  // builds button/link html 
  switch(buttonType){
    case "link":
      buttonHTML = buildLinkButton(title, link, classes);
      break;
    case "section": 
      buttonHTML = buildSectionButton(title, classes);
      break;
    default:
      console.error("***ERROR: Attempting to build a navigation item that is neither a button or a link!!!*** ");
      break;
  }


  return buttonHTML;
}
                                                                                     
// builds a button that is intended to open up a new section of children
// * note: href is optional, if included, it will create an additional sublink for the given href with the same title as the button in the proceding navigation item
function buildSectionButton(title, sectionClass){
  sectionClass = sectionClass || "";
  var buttonHTML = `<li class="mobileNavItem">
                      <button name="navigation-button" onclick="buildNavigationLevel('${title}')" class="${sectionClass}">
                        ${title}
                      </button>
                    </li>`;

  return buttonHTML;
}

// builds a button that is intended to link to a new page
function buildLinkButton(title, href, linkClass){
  linkClass = linkClass || "";
  href = href || convertStringToUrl(title);
  isExternal = (href.slice(0,4) == "http")?true:false;

  if(title != "" && typeof title != "object"){
    return `<li class="mobileNavItem"><a href="${href}" class="${linkClass} ${shouldBuildString(isExternal,"icon__external-link--after icon externalLink")}">${title}</a></li>`;
  } 
  else
  {
    return "";
  }
} 

// builds a back button that sends the user to the initial starting menu for the hamburger menu
function buildBackButton(){ 
  return shouldBuildString(!isTopLevel,
    `<li class="mobileNavItem"><button name="navigation-button" onclick="buildNavigationLevel(nav)">Back</button></li>`
  );
}

// removes any navigation from a given piece of data that has no title, no link, or no subItems
function removeNonCriticalNavigation(navData){
  revisedData = [];
  
  for (let i = 0; i < navData.length; i++) {
    const element = navData[i];
    if (element.title != "" || element.children != undefined)
      revisedData.push(element);
  }

  return revisedData;
}
