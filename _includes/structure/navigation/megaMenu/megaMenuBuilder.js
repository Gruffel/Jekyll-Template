//prebuilt variables:
  // nav (navigation data),
  // navigationWrapper (nav DOM element with anvlink ID),
  // navigationData (processed navigation.json file)
//prebuilt functions:
  // convertStringToUrl (turns a string into an acceptable SEO friendly URL according to special characters set up in navigation data)
  // shouldBuildString (returns the full string if the bool is true, otherwise returns an empty string, allows for easy nesting of other strings)
  // buildImageHTML (takes a path and an alt and builds an image using the imgX standards)
  // getNavFromTitle (takes a string title and returns the navigation data that title. returns undefined if there is no result)


// initializes the building of the navigation
function initiateMegaMenuBuild()
{
    var html = "<ul class='topNavItems'>";

    // loop through each heading item in the nav and initiate the heading build function
    for (let i = 0; i < nav.length; i++) {
        const topNavItem = nav[i];
        html += `${getHeading(topNavItem)}`;
    }
    html += '</ul>';

    navigationWrapper.innerHTML = html; // sets the final level of html
}

// builds & returns a single heading/topNav item and (if it has them) builds the drop down menu with each respective section
function getHeading(topNavItem){
    // find special cases for the heading (does it have children, is it a link, is it the active top navigation)
    var isLink = (topNavItem['href'] != undefined && topNavItem['href'] != ""); // is this top navigation a link item
    var isExternal = (isLink && topNavItem['href'].slice(0,4) == "http")? true : false; // if the item is a link and its href starts with http the link is external
    var sectionCount = (topNavItem['children'] != undefined)? topNavItem['children'].length : 0; // how many children are in this top navigation item
    var topNavURLBase = (isLink)? topNavItem['href'] :
                        (topNavItem['urlOverride'] != undefined)? topNavItem['urlOverride'] :
                        convertStringToUrl(topNavItem['title']); // if the item is a link, the baseURL is the link, if it is not a link, if it has a url override use that, otherwise, convert the title to a link
    var isActive = (window.location.pathname.includes(topNavURLBase)); // is this page (or a subpage underneath it) the current page
    var headingHTML = "";

    // loop through and initiate the section build for this heading element (if there are children within this element)
    if(sectionCount > 0){
        var sectionHTML = `<div class='subMenu'><ul class='navMenu max-width__tier-1' style='column-count: ${sectionCount};'>`;
        for (let i = 0; i < topNavItem['children'].length; i++) {
            const section = topNavItem['children'][i];
            sectionHTML += getSection(section);
        }
        sectionHTML += "</ul></div>";
    }


    // write the heading title of the navigation item and wrap it in the approriate html


    headingHTML += `<li class='${shouldBuildString(topNavItem['class'] != undefined, topNavItem['class'])} ${shouldBuildString(isActive,'activeNav')} top-navigation'>
                        <a href="${shouldBuildString(isLink,topNavItem['href'])}" class='${shouldBuildString(isExternal,"icon__external-link--after icon externalLink")} top-navigation'>
                            ${topNavItem['title']}
                        </a>
                        ${shouldBuildString(sectionCount != 0, sectionHTML)}
                    </li>`;

    return headingHTML;
}

// builds a single section within a dropdown menu along with any stylizations (such as images or unique classes) as well as children
function getSection(section){
    // determine stylization parameters of section (is image, is link, is icon)
    var isLink = section['href'] != undefined && section['href'] != "";
    var isExternal = (isLink && section['href'].slice(0,4) == "http")?true:false; // if the section is a link and the href starts with http, then the link is external and should have an icon labelling it as such
    var layout = (section['img'] != undefined && section['img'] != "")? "image" :
                 (section['icon'] != undefined && section['icon'] != "")? "icon" :
                 "default";
    var hasChildren = (section['children'] != undefined && section['children'].length != 0);

    //mark the HTML for the nav section with the appropriate class names according to the desired layout
    var sectionHTML = `<li class='navSection ${shouldBuildString(layout=="image" && isLink, `navImage`)} ${shouldBuildString(layout=="icon" && isLink, `navLinkIcon`)} ${shouldBuildString(section['class'] != undefined, section['class'])}' ${shouldBuildString(layout!="default", `style='display: block;'`)}>`;

    // wrap the section in appropriate section html
    if(layout == "default")
        sectionHTML += `<a href='${shouldBuildString(isLink, section['href'])}' tabIndex="0" class="${shouldBuildString(isExternal,"icon__external-link--after icon externalLink")} navSectionHeading">${section['title']}</a>`;
    else if(layout == "image"){
        if(section['href'] != undefined && section['href'] != "") {
            sectionHTML += `<a href='${shouldBuildString(isLink, section['href'])}' tabIndex="0" class="${shouldBuildString(isExternal,"icon__external-link--after icon externalLink")} navSectionHeading navImage">`;
            sectionHTML += buildImageHTML(section['img'], section['imgAlt']);
            sectionHTML += `${section['title']}</a>`;
            }
          else{
            sectionHTML += buildImageHTML(section['img'], section['imgAlt']);
            sectionHTML += `${section['title']}</a>`;
            }
          }
    else if (layout == "icon"){
        sectionHTML += `
        <div class='navLinkIcon__link-wrapper'>
          <a href='${shouldBuildString(isLink, section['href'])}' class='${shouldBuildString(isExternal,"icon__external-link--after icon externalLink")} navLinkIcon__link'>
              <div class='icon icon__${section['icon']}--before navLinkIcon' display="block"></div><h2>${section['title']}</h2>
          </a>
        </div>`;
    }

    // Loop through and initiate the link build for this section (if there are children in this section)
    if(hasChildren){
        sectionHTML += "<ul>"
        for (let i = 0; i < section['children'].length; i++) {
            const link = section['children'][i];
            sectionHTML += getLink(link);
        }
        sectionHTML += "</ul>"
    }

    sectionHTML += "</li>";

    return sectionHTML;
}

// writes the individual link underneath a given section
function getLink(link){
    var linkHTML;
    var isExternal = (typeof link == "object" && link["href"].slice(0,4) == "http")? true:false; // if the link is an object with an href that starts with 'http' then the link is external

    if(typeof link == "string")  linkHTML = `<li class='navLink '><a href="${convertStringToUrl(link)}">${link}</a></li>`;
    else linkHTML = `<li class='${shouldBuildString(isExternal,"icon__external-link--after icon externalLink")} navLink ${link['class']}'><a href="${link['href']}">${link['title']}</a></li>`;

    return linkHTML;
}
