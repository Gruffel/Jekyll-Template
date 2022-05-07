<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>
<xsl:param name="search_script"/>
<xsl:param name="no_results"/>

<!-- This shows/hides the search info bar -->
<xsl:variable name="show_search_info">1</xsl:variable>

<!-- This shows/hides the Previous and Next links at the top of the page -->
<xsl:variable name="show_top_navigation">1</xsl:variable>

<!-- This shows/hides the Sort by date/Sort by relevance links -->
<xsl:variable name="show_sort_by">1</xsl:variable>

<!-- This shows/hides the spelling suggestions (aka Did you mean?) -->
<xsl:variable name="show_spelling">1</xsl:variable>
<xsl:variable name="spelling_text">Did you mean:</xsl:variable>

<!-- This shows/hides the synonyms suggestions -->
<xsl:variable name="show_synonyms">1</xsl:variable>
<xsl:variable name="synonyms_text">You could also try:</xsl:variable>

<!-- This shows/hides keymatch suggestions -->
<xsl:variable name="show_keymatch">1</xsl:variable>
<xsl:variable name="keymatch_text">Quick Links</xsl:variable>

<!-- These are used for reformatting keyword matches (The bold words in titles and snippets -->
<xsl:variable name="res_keyword_color"></xsl:variable>
<xsl:variable name="res_keyword_size"></xsl:variable>
<xsl:variable name="res_keyword_format">strong</xsl:variable>

<!-- This allows you to truncated result URLs (for long URLs) -->
<xsl:variable name="truncate_result_urls">1</xsl:variable>
<xsl:variable name="truncate_result_url_length">100</xsl:variable>

<!-- Misc. variables that can be shown or hidden in results -->
<xsl:variable name="show_meta_tags">0</xsl:variable>
<xsl:variable name="show_res_size">0</xsl:variable>
<xsl:variable name="show_res_date">0</xsl:variable>

<!-- Turns access keys on/off -->
<xsl:variable name="use_accesskeys">1</xsl:variable>

<!-- Customizable error text -->
<xsl:variable name="server_error_msg_text">A server error has occurred.</xsl:variable>
<xsl:variable name="server_error_des_text">Check server response code in details.</xsl:variable>
<xsl:variable name="xml_error_msg_text">Unknown XML result type.</xsl:variable>
<xsl:variable name="xml_error_des_text">View page source to see the offending XML.</xsl:variable>

<!-- What is shown for an empty result set -->
<xsl:template name="no_RES">
  <xsl:param name="query"/>
  <div id="search_error">
    <p>
      <xsl:text>Your search - </xsl:text>
      <strong><xsl:value-of select="$query"/></strong>
      <xsl:text> - did not match any documents.</xsl:text>
      <xsl:text> </xsl:text>
      <span>
        <xsl:text>No pages were found containing </xsl:text>
        <strong>"<xsl:value-of select="$query"/>"</strong>
        <xsl:text>.</xsl:text>
      </span>
    </p>
    <p>Suggestions:</p>
    <ul>
      <li>Make sure all words are spelled correctly.</li>
      <li>Try different keywords.</li>
 	    <li>Try more general keywords.</li>
    </ul>
    <xsl:value-of select="$no_results" disable-output-escaping="yes"/>
  </div>
</xsl:template>

<!-- **********************************************************************
		 DO NOT CUSTOMIZE ANYTHING BELOW THIS POINT!
		 ********************************************************************** -->

<!-- URL variables -->
<!-- *** if this is a test search (help variable)-->
<xsl:variable name="is_test_search" select="/GSP/PARAM[@name='testSearch']/@value"/>

<!-- *** if this is a search within results search *** -->
<xsl:variable name="swrnum">
  <xsl:choose>
    <xsl:when test="/GSP/PARAM[(@name='swrnum') and (@value!='')]">
      <xsl:value-of select="/GSP/PARAM[@name='swrnum']/@value"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="0"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- *** base_url: collection info *** -->
<xsl:variable name="base_url">
  <xsl:for-each
    select="/GSP/PARAM[@name = 'client' or
                       @name = 'site' or
                       @name = 'num' or
                       @name = 'output' or
                       @name = 'proxystylesheet' or
                       @name = 'access' or
                       @name = 'lr' or
                       @name = 'ie']">
    <xsl:value-of select="@name"/>=<xsl:value-of select="@original_value"/>
    <xsl:if test="position() != last()">&amp;</xsl:if>
  </xsl:for-each>
</xsl:variable>

<!-- *** synonym_url: does not include q, as_q, and start elements *** -->
<xsl:variable name="synonym_url"><xsl:for-each
  select="/GSP/PARAM[(@name != 'q') and
                     (@name != 'as_q') and
                     (@name != 'swrnum') and
                     (@name != 'ie') and
                     (@name != 'start') and
                     (@name != 'epoch' or $is_test_search != '') and
                     not(starts-with(@name, 'metabased_'))]">
    <xsl:value-of select="@name"/><xsl:text>=</xsl:text>
    <xsl:value-of select="@original_value"/>
    <xsl:if test="position() != last()">
      <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<!-- *** search_url *** -->
<xsl:variable name="search_url">
  <xsl:for-each select="/GSP/PARAM[(@name != 'start') and
                                   (@name != 'swrnum') and
                     (@name != 'epoch' or $is_test_search != '') and
                     not(starts-with(@name, 'metabased_'))]">
    <xsl:value-of select="@name"/><xsl:text>=</xsl:text>
    <xsl:value-of select="@original_value"/>
    <xsl:if test="position() != last()">
      <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:variable>

<!-- *** filter_url: everything except resetting "filter=" *** -->
<xsl:variable name="filter_url">$search_script?<xsl:for-each
  select="/GSP/PARAM[(@name != 'filter') and
                     (@name != 'epoch' or $is_test_search != '') and
                     not(starts-with(@name, 'metabased_'))]">
    <xsl:value-of select="@name"/><xsl:text>=</xsl:text>
    <xsl:value-of select="@original_value"/>
    <xsl:if test="position() != last()">
      <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
    </xsl:if>
  </xsl:for-each>
  <xsl:text disable-output-escaping='yes'>&amp;filter=</xsl:text>
</xsl:variable>

<!-- *** db_url_protocol: googledb:// *** -->
<xsl:variable name="db_url_protocol">googledb://</xsl:variable>

<!-- Search Parameters -->
<!-- *** num_results: actual num_results per page *** -->
<xsl:variable name="num_results">
  <xsl:choose>
    <xsl:when test="/GSP/PARAM[(@name='num') and (@value!='')]">
      <xsl:value-of select="/GSP/PARAM[@name='num']/@value"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="10"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- *** space_normalized_query: q = /GSP/Q *** -->
<xsl:variable name="qval">
  <xsl:value-of select="/GSP/Q"/>
</xsl:variable>

<xsl:variable name="qval_uri">
  <xsl:call-template name="uriencode">
    <xsl:with-param name="text" select="$qval"/>
  </xsl:call-template>
</xsl:variable>

<xsl:variable name="space_normalized_query">
  <xsl:value-of select="normalize-space($qval)" disable-output-escaping="yes"/>
</xsl:variable>

<xsl:variable name="access">
  <xsl:choose>
    <xsl:when test="/GSP/PARAM[(@name='access') and ((@value='s') or (@value='a'))]">
      <xsl:value-of select="/GSP/PARAM[@name='access']/@original_value"/>
    </xsl:when>
    <xsl:otherwise>p</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- Figure out what kind of page this is -->
<xsl:template match="GSP">
  <div>
  <xsl:choose>
    <xsl:when test="Q">
    	<xsl:attribute name="id">results</xsl:attribute>
    	<xsl:call-template name="search_results"/>
    </xsl:when>
    <xsl:when test="ERROR">
      <xsl:attribute name="id">error</xsl:attribute>
      <xsl:call-template name="error_page">
        <xsl:with-param name="errorMessage" select="$server_error_msg_text"/>
        <xsl:with-param name="errorDescription" select="$server_error_des_text"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="id">error</xsl:attribute>
      <xsl:call-template name="error_page">
        <xsl:with-param name="errorMessage" select="$xml_error_msg_text"/>
        <xsl:with-param name="errorDescription" select="$xml_error_des_text"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  </div>
</xsl:template>

<!-- Search results -->
<xsl:template name="search_results">
  <!-- *** Top separation bar *** -->
  <xsl:if test="Q != ''">
    <xsl:call-template name="top_sep_bar">
      <xsl:with-param name="show_info" select="$show_search_info"/>
      <xsl:with-param name="time" select="TM"/>
    </xsl:call-template>
  </xsl:if>

  <!-- *** Handle results (if any) *** -->
  <xsl:choose>
    <xsl:when test="RES or GM or Spelling or Synonyms or CT or /GSP/ENTOBRESULTS">
      <xsl:call-template name="results">
        <xsl:with-param name="query" select="Q"/>
        <xsl:with-param name="time" select="TM"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="Q=''">
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="no_RES">
        <xsl:with-param name="query" select="Q"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Sort-by criteria: sort by date/relevance -->
<xsl:template name="sort_by">
	<p class="sort_by">
  <xsl:variable name="sort_by_url"><xsl:for-each
    select="/GSP/PARAM[(@name != 'sort') and
                       (@name != 'start') and
                       (@name != 'epoch' or $is_test_search != '') and
                       not(starts-with(@name, 'metabased_'))]">
      <xsl:value-of select="@name"/><xsl:text>=</xsl:text>
      <xsl:value-of select="@original_value"/>
      <xsl:if test="position() != last()">
        <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="sort_by_relevance_url">
    <xsl:value-of select="$sort_by_url"/>&amp;sort=date%3AD%3AL%3Ad1</xsl:variable>

  <xsl:variable name="sort_by_date_url">
    <xsl:value-of select="$sort_by_url"/>&amp;sort=date%3AD%3AS%3Ad1</xsl:variable>

    <xsl:choose>
      <xsl:when test="/GSP/PARAM[@name = 'sort' and (starts-with(@value,'date:D:S') or starts-with(@value,'date:A:S'))]">
        <strong>Sort by date</strong><xsl:text> / </xsl:text>
        <a href="{$search_script}?{$sort_by_relevance_url}">Sort by relevance</a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$search_script}?{$sort_by_date_url}">Sort by date</a> / <strong>Sort by relevance</strong>
      </xsl:otherwise>
    </xsl:choose>
  </p>
</xsl:template>

<!-- Output all results -->
<xsl:template name="results">
  <xsl:param name="query"/>
  <xsl:param name="time"/>

  <!-- *** Add top navigation/sort-by bar *** -->
  <xsl:if test="($show_top_navigation != '0' or $show_sort_by != '0') and count(RES/R)>0">
    <div id="nav_sort">
      <xsl:if test="$show_top_navigation != '0'">
        <xsl:call-template name="google_navigation">
          <xsl:with-param name="prev" select="RES/NB/PU"/>
          <xsl:with-param name="next" select="RES/NB/NU"/>
          <xsl:with-param name="view_begin" select="RES/@SN"/>
          <xsl:with-param name="view_end" select="RES/@EN"/>
          <xsl:with-param name="guess" select="RES/M"/>
          <xsl:with-param name="navigation_style" select="'top'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$show_sort_by != '0'">
        <xsl:call-template name="sort_by"/>
      </xsl:if>
    </div>
  </xsl:if>

  <!-- *** Handle spelling suggestions, if any *** -->
  <xsl:if test="$show_spelling != '0'">
    <xsl:call-template name="spelling"/>
  </xsl:if>

  <!-- *** Handle synonyms, if any *** -->
  <xsl:if test="$show_synonyms != '0'">
    <xsl:call-template name="synonyms"/>
  </xsl:if>

  <!-- *** Output results details *** -->

  <!-- for keymatch results -->
  <xsl:if test="$show_keymatch != '0' and count(/GSP/GM)>0">
    <div id="keymatch">
      <h3><xsl:value-of select="$keymatch_text"/></h3>
      <ul>
        <xsl:apply-templates select="/GSP/GM"/>
      </ul>
    </div>
  </xsl:if>

  <!-- for real results -->
  <xsl:if test="count(RES/R)>0">
    <div id="result_items">
      <dl>
        <xsl:apply-templates select="RES/R">
          <xsl:with-param name="query" select="$query"/>
        </xsl:apply-templates>
      </dl>

      <!-- *** Filter note (if needed) *** -->
      <xsl:if test="(RES/FI) and (not(RES/NB/NU))">
        <p id="om"><em>In order to show you the most relevant results, we have omitted some entries very similar to the <xsl:value-of select="RES/@EN"/> already displayed. <span>If you like, you can <a href="{$filter_url}0">repeat the search with the omitted results included</a>.</span></em></p>
      </xsl:if>
    </div>

    <xsl:call-template name="google_navigation">
      <xsl:with-param name="prev" select="RES/NB/PU"/>
      <xsl:with-param name="next" select="RES/NB/NU"/>
      <xsl:with-param name="view_begin" select="RES/@SN"/>
      <xsl:with-param name="view_end" select="RES/@EN"/>
      <xsl:with-param name="guess" select="RES/M"/>
      <xsl:with-param name="navigation_style" select="'google'"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- Stopwords suggestions in result page -->
<xsl:template name="stopwords">
  <xsl:variable name="stopwords_suggestions1">
    <xsl:call-template name="replace_string">
      <xsl:with-param name="find" select="'/help/basics.html#stopwords'"/>
      <xsl:with-param name="replace" select="'user_help.html#stop'"/>
      <xsl:with-param name="string" select="/GSP/CT"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="stopwords_suggestions2">
    <xsl:call-template name="replace_string">
      <xsl:with-param name="find" select="'/help/basics.html'"/>
      <xsl:with-param name="replace" select="'user_help.html'"/>
      <xsl:with-param name="string" select="$stopwords_suggestions1"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="stopwords_suggestions3">
    <xsl:call-template name="replace_string">
      <xsl:with-param name="find" select="'A HREF'"/>
      <xsl:with-param name="replace" select="'a href'"/>
      <xsl:with-param name="string" select="$stopwords_suggestions2"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="stopwords_suggestions">
    <xsl:call-template name="replace_string">
      <xsl:with-param name="find" select="'&lt;/A&gt;]&lt;br&gt;'"/>
      <xsl:with-param name="replace" select="'&lt;/a&gt;]&lt;br /&gt;'"/>
      <xsl:with-param name="string" select="$stopwords_suggestions3"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="/GSP/CT">
    <xsl:value-of disable-output-escaping="yes"
      select="$stopwords_suggestions"/>
  </xsl:if>
</xsl:template>

<!-- Spelling suggestions in result page -->
<xsl:template name="spelling">
  <xsl:if test="/GSP/Spelling/Suggestion">
    <p id="didyoumean">
      <strong><xsl:value-of select="$spelling_text"/></strong><xsl:text> </xsl:text>
      <a href="{$search_script}?q={/GSP/Spelling/Suggestion[1]/@q}&amp;spell=1&amp;{$base_url}&amp;filter=0">
     <xsl:variable name="suggestion">
       <xsl:call-template name="reformat_semantic">
         <xsl:with-param name="markup" select="/GSP/Spelling/Suggestion[1]"/>
       </xsl:call-template>
     </xsl:variable>
      <xsl:value-of disable-output-escaping="yes" select="$suggestion"/>
      </a>
    </p>
  </xsl:if>
</xsl:template>

<!-- Synonym suggestions in result page -->
<xsl:template name="synonyms">
  <xsl:if test="/GSP/Synonyms/OneSynonym">
  <p id="sy">
    <xsl:value-of select="$synonyms_text"/><xsl:text> </xsl:text>
    <xsl:for-each select="/GSP/Synonyms/OneSynonym">
      <a href="{$search_script}?q={@q}&amp;{$synonym_url}">
        <xsl:value-of disable-output-escaping="yes" select="."/>
      </a>
      <xsl:text> </xsl:text>
    </xsl:for-each>
  </p>
  </xsl:if>
</xsl:template>

<!-- Truncation functions -->
<xsl:template name="truncate_url">
  <xsl:param name="t_url"/>
  <xsl:choose>
    <xsl:when test="string-length($t_url) &lt; $truncate_result_url_length">
      <xsl:value-of select="$t_url"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="first" select="substring-before($t_url, '/')"/>
      <xsl:variable name="last">
        <xsl:call-template name="truncate_find_last_token">
          <xsl:with-param name="t_url" select="$t_url"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="path_limit" select="$truncate_result_url_length - (string-length($first) + string-length($last) + 1)"/>
      <xsl:choose>
        <xsl:when test="$path_limit &lt;= 0">
          <xsl:value-of select="concat(substring($t_url, 1, $truncate_result_url_length), '...')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="chopped_path">
            <xsl:call-template name="truncate_chop_path">
              <xsl:with-param name="path" select="substring($t_url, string-length($first) + 2, string-length($t_url) - (string-length($first) + string-length($last) + 1))"/>
              <xsl:with-param name="path_limit" select="$path_limit"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="concat($first, '/.../', $chopped_path, $last)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="truncate_find_last_token">
  <xsl:param name="t_url"/>
  <xsl:choose>
    <xsl:when test="contains($t_url, '/')">
      <xsl:call-template name="truncate_find_last_token">
        <xsl:with-param name="t_url" select="substring-after($t_url, '/')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$t_url"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="truncate_chop_path">
  <xsl:param name="path"/>
  <xsl:param name="path_limit"/>
  <xsl:choose>
    <xsl:when test="string-length($path) &lt;= $path_limit">
      <xsl:value-of select="$path"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="truncate_chop_path">
        <xsl:with-param name="path" select="substring-after($path, '/')"/>
        <xsl:with-param name="path_limit" select="$path_limit"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- A single result -->
<xsl:template match="R">
  <xsl:param name="query"/>
  <xsl:variable name="display_url_tmp" select="substring-after(UD, '://')"/>
  <xsl:variable name="display_url">
    <xsl:choose>
      <xsl:when test="$display_url_tmp">
        <xsl:value-of select="$display_url_tmp"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-after(U, '://')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="escaped_url" select="substring-after(UE, '://')"/>
  <xsl:variable name="protocol" select="substring-before(U, '://')"/>
  <xsl:variable name="full_url" select="UE"/>
  <xsl:variable name="crowded_url" select="HN/@U"/>
  <xsl:variable name="crowded_display_url" select="HN"/>
  <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <xsl:variable name="temp_url" select="substring-after(U, '://')"/>
  <xsl:variable name="url_indexed" select="not(starts-with($temp_url, 'noindex!/'))"/>
  <xsl:variable name="stripped_url">
    <xsl:choose>
      <xsl:when test="$truncate_result_urls != '0'">
        <xsl:call-template name="truncate_url">
          <xsl:with-param name="t_url" select="$display_url"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$display_url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="result_num" select="(@N)-(/GSP/RES/@SN)+1"/>

  <!-- *** Indent as required (only supports 2 levels) *** -->
  <xsl:variable name="level"><xsl:if test="@L='2'">l2</xsl:if></xsl:variable>

  <!-- *** Result Header *** -->
  <dt>
    <xsl:if test="$level != ''">
      <xsl:attribute name="class"><xsl:value-of select="$level"/></xsl:attribute>
    </xsl:if>

    <!-- *** Result Title (including PDF tag and hyperlink) *** -->
    <xsl:variable name="res_type">
      <xsl:choose>
        <xsl:when test="@MIME='text/html' or @MIME='' or not(@MIME)"></xsl:when>
        <xsl:when test="@MIME='text/plain'">[TEXT]</xsl:when>
        <xsl:when test="@MIME='application/rtf'">[RTF]</xsl:when>
        <xsl:when test="@MIME='application/pdf'">[PDF]</xsl:when>
        <xsl:when test="@MIME='application/postscript'">[PS]</xsl:when>
        <xsl:when test="@MIME='application/vnd.ms-powerpoint'">[MS POWERPOINT]</xsl:when>
        <xsl:when test="@MIME='application/vnd.ms-excel'">[MS EXCEL]</xsl:when>
        <xsl:when test="@MIME='application/msword'">[MS WORD]</xsl:when>
        <xsl:otherwise>
          <xsl:variable name="extension">
            <xsl:call-template name="last_substring_after">
              <xsl:with-param name="string" select="substring-after(
                                                    substring-after(U,'://'),
                                                    '/')"/>
              <xsl:with-param name="separator" select="'.'"/>
              <xsl:with-param name="fallback" select="'UNKNOWN'"/>
            </xsl:call-template>
          </xsl:variable>
          [<xsl:value-of select="translate($extension,$lower,$upper)"/>]
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$res_type != ''">
      <strong class="mimetype"><xsl:value-of select="$res_type"/></strong>
      <xsl:text> </xsl:text>
    </xsl:if>

    <xsl:variable name="url_cdata">
      <xsl:choose>
        <xsl:when test="T">
          <xsl:call-template name="reformat_keyword">
            <xsl:with-param name="orig_string" select="T"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$stripped_url"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$url_indexed">
      	<xsl:if test="substring-before($stripped_url, '.') = 'secure'">
          <span class="secure_result">
         		<img src="data:image/gif;base64,R0lGODlhDgAOANUAANnZ2Xh4eLu7uwICAm5uboaGhnx8fDw8PD8/P4WFhQ4ODiAgIGdnZ9zc3IqKioiIiK2trS0tLUxMTJWVlTs7O319fX9/f2VlZWtra8DAwFRUVDU1NXd3d+Tk5DExMY+Pj0VFRd3d3SYmJkFBQY6OjpGRkdfX17a2ttra2uDg4BoaGgwMDEdHRzAwMFdXV3p6epeXl8nJyd7e3tXV1aCgoNPT0w0NDcbGxkBAQEpKSmlpaWZmZv///wAAAAAAAAAAACH5BAAAAAAALAAAAAAOAA4AAAZwwNtuSCwObz2ccskceXS9nBRTQwFgEikCKtXMaDmDKbCJLLg5XailWj0mtl6PS2HdBvJASSGHigYEKQEEDBAnIH1yPTc8jY0yH4lyAo6NAAWSPZSVl5kZlTwNDpkxoB0kmS4cLwkWFRcHfUiKtLQ3QQA7" alt="Secure Result" />
         	</span>
        </xsl:if>
        <a class="title">
          <xsl:attribute name="href">
            <xsl:choose>
              <!-- *** URI for smb/NFS must be escaped - it appears in the URI query *** -->
              <xsl:when test="$protocol='smb' or $protocol='nfs'">
                <xsl:value-of disable-output-escaping='yes'
                              select="concat($protocol,'/', substring-after(U,'://'))"/>
              </xsl:when>
              <xsl:when test="starts-with(U, $db_url_protocol)">
                <xsl:value-of disable-output-escaping='yes'
                              select="concat('db/', substring-after(U,'://'))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping='yes' select="U"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <!-- *** Accesskeys run from 1-9, then 0 for result 10. No more than that. *** -->
          <xsl:if test="$use_accesskeys != '0' and $result_num &lt;= 10">
            <xsl:attribute name="accesskey">
              <xsl:value-of select="$result_num mod $num_results"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="$url_cdata" disable-output-escaping="yes"/>
        </a>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$url_cdata" disable-output-escaping="yes"/></xsl:otherwise>
    </xsl:choose>
  </dt>

  <dd>
    <xsl:if test="$level != ''">
      <xsl:attribute name="class"><xsl:value-of select="$level"/></xsl:attribute>
    </xsl:if>

    <!-- *** Snippet Box *** -->
    <xsl:call-template name="reformat_keyword">
      <xsl:with-param name="orig_string" select="S"/>
      <xsl:with-param name="type" select="'snippet'"/>
    </xsl:call-template>

    <!-- *** Meta tags *** -->
    <xsl:if test="$show_meta_tags != '0' and count(MT)>0">
      <ul class="mt">
        <xsl:apply-templates select="MT"/>
      </ul>
    </xsl:if>

    <p class="nolink_url">
      <!-- *** URL *** -->
      <xsl:choose>
        <xsl:when test="not($url_indexed)">
          <xsl:if test="($show_res_size!='0') or ($show_res_date!='0')">
            <xsl:text>Not Indexed:</xsl:text>
            <xsl:value-of select="$stripped_url"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$stripped_url"/>
        </xsl:otherwise>
      </xsl:choose>

      <!-- *** Miscellaneous (- size - date - cache) *** -->
      <xsl:if test="$url_indexed">
        <xsl:apply-templates select="HAS/C">
          <xsl:with-param name="stripped_url" select="$stripped_url"/>
          <xsl:with-param name="escaped_url" select="$escaped_url"/>
          <xsl:with-param name="query" select="$query"/>
          <xsl:with-param name="mime" select="@MIME"/>
          <xsl:with-param name="date" select="FS[@NAME='date']/@VALUE"/>
        </xsl:apply-templates>
      </xsl:if>
    </p>

    <!-- *** Link to more links from this site *** -->
    <!-- *** Link to aggregated results from database source *** -->
    <xsl:if test="HN">
      <p class="fm">[ <a class="f" href="{$search_script}?as_sitesearch={$crowded_url}&amp;{$search_url}">More results from <xsl:value-of select="$crowded_display_url"/></a> ] <xsl:if test="starts-with($crowded_url, $db_url_protocol)">[ <a class="f" href="dbaggr?sitesearch={$crowded_url}&amp;{$search_url}">View all data</a> ]</xsl:if></p>
    </xsl:if>

    <!-- *** Result Footer *** -->
  </dd>
</xsl:template>

<!-- Meta tag values within a result -->
<xsl:template match="MT">
  <li><span class="f"><xsl:value-of select="@N"/>: </span><xsl:value-of select="@V"/></li>
</xsl:template>

<!-- A single keymatch result -->
<xsl:template match="GM">
  <li><a href="{GL}"><xsl:value-of select="GD"/></a> - <xsl:value-of select="GL"/></li>
</xsl:template>

<!-- Variables for reformatting keyword-match display -->
<xsl:variable name="keyword_orig_start" select="'&lt;b&gt;'"/>
<xsl:variable name="keyword_orig_end" select="'&lt;/b&gt;'"/>

<xsl:variable name="keyword_reformat_start">
  <xsl:if test="$res_keyword_format">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="$res_keyword_format"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:if>
  <xsl:if test="($res_keyword_size) or ($res_keyword_color)">
    <xsl:text>&lt;span style="</xsl:text>
    <xsl:if test="$res_keyword_size">
      <xsl:text>text-size:</xsl:text>
      <xsl:value-of select="$res_keyword_size"/>
      <xsl:text>;</xsl:text>
    </xsl:if>
    <xsl:if test="$res_keyword_color">
      <xsl:text>color:</xsl:text>
      <xsl:value-of select="$res_keyword_color"/>
      <xsl:text>;</xsl:text>
    </xsl:if>
    <xsl:text>"&gt;</xsl:text>
  </xsl:if>
</xsl:variable>

<xsl:variable name="keyword_reformat_end">
  <xsl:if test="($res_keyword_size) or ($res_keyword_color)">
    <xsl:text>&lt;/span&gt;</xsl:text>
  </xsl:if>
  <xsl:if test="$res_keyword_format">
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="$res_keyword_format"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:if>
</xsl:variable>

<!-- Reformat the keyword match display in a title/snippet string -->
<xsl:template name="reformat_keyword">
  <xsl:param name="orig_string"/>
  <xsl:param name="type"/>

  <xsl:variable name="reformatted_1">
    <xsl:call-template name="replace_string">
      <xsl:with-param name="find" select="$keyword_orig_start"/>
      <xsl:with-param name="replace" select="$keyword_reformat_start"/>
      <xsl:with-param name="string" select="$orig_string"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="reformatted_2">
    <xsl:call-template name="replace_string">
      <xsl:with-param name="find" select="$keyword_orig_end"/>
      <xsl:with-param name="replace" select="$keyword_reformat_end"/>
      <xsl:with-param name="string" select="$reformatted_1"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Swap out presentation-related elements with semantic equivalents -->
  <xsl:variable name="reformatted_3">
    <xsl:call-template name="reformat_semantic">
      <xsl:with-param name="markup" select="$reformatted_2"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Swap out presentation-related br in second half of snippets with a span -->
  <xsl:choose>
    <xsl:when test="$type = 'snippet'">
      <p class="snippet">
        <xsl:variable name="br_html">&lt;br&gt;</xsl:variable>
        <xsl:choose>
          <!-- Presuming one (and only one) br exists ... -->
          <xsl:when test="contains($reformatted_3, $br_html)">
            <xsl:value-of disable-output-escaping='yes' select="substring-before($reformatted_3, $br_html)"/>
            <span class="snippet_line2">
              <xsl:value-of disable-output-escaping='yes' select="substring-after($reformatted_3, $br_html)"/>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping='yes' select="$reformatted_3"/>
          </xsl:otherwise>
        </xsl:choose>
      </p>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of disable-output-escaping='yes' select="$reformatted_3"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Helper templates for converting standard-issue HTML elements to more semantic variants -->
<xsl:template name="reformat_semantic">
  <xsl:param name="markup"/>

  <!-- List of elements we'll be replacing (keep space at the end) -->
  <xsl:param name="from" select="'b i '"/>
  <xsl:param name="to" select="'strong em '"/>

  <!-- Get the next pair of search/replace candidates -->
  <xsl:variable name="find" select="substring-before($from, ' ')"/>
  <xsl:variable name="replace" select="substring-before($to, ' ')"/>

  <xsl:choose>
    <xsl:when test="$find">
      <xsl:variable name="markup-new-2">
        <xsl:call-template name="replace_string">
          <xsl:with-param name="find" select="concat('&lt;',$find,'&gt;')"/>
          <xsl:with-param name="replace" select="concat('&lt;',$replace,'&gt;')"/>
          <xsl:with-param name="string" select="$markup"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="markup-new">
        <xsl:call-template name="replace_string">
          <xsl:with-param name="find" select="concat('&lt;/',$find,'&gt;')"/>
          <xsl:with-param name="replace" select="concat('&lt;/',$replace,'&gt;')"/>
          <xsl:with-param name="string" select="$markup-new-2"/>
        </xsl:call-template>
      </xsl:variable>
      <!-- Recursion: It's fun for the whole family! -->
      <xsl:call-template name="reformat_semantic">
        <xsl:with-param name="markup" select="$markup-new"/>
        <xsl:with-param name="from" select="substring-after($from, ' ')"/>
        <xsl:with-param name="to" select="substring-after($to, ' ')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$markup"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Helper templates for generating a result item -->
<!-- *** Miscellaneous: - size - date - cache *** -->
<xsl:template match="C">
  <xsl:param name="stripped_url"/>
  <xsl:param name="escaped_url"/>
  <xsl:param name="query"/>
  <xsl:param name="mime"/>
  <xsl:param name="date"/>

  <xsl:variable name="docid"><xsl:value-of select="@CID"/></xsl:variable>

  <xsl:if test="$show_res_size != '0'">
    <xsl:if test="not(@SZ='')">
      <xsl:text> - </xsl:text>
      <xsl:value-of select="@SZ"/>
    </xsl:if>
  </xsl:if>

  <xsl:if test="$show_res_date != '0'">
    <xsl:if test="($date != '') and
                  (translate($date, '-', '') &gt; 19500000) and
                  (translate($date, '-', '') &lt; 21000000)">
      <xsl:text> - </xsl:text>
      <xsl:value-of select="$date"/>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- Google navigation directional endpoints: first/prev/next/last -->
<xsl:template name="nav_dir">
  <xsl:param name="style"/>
  <xsl:param name="type"/>
  <xsl:param name="nav"/>
  <xsl:param name="view_begin"/>

  <xsl:variable name="fontclass">
    <xsl:if test="$style != 'top'"><xsl:text> </xsl:text>b</xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$type = 'prev'">
      <xsl:choose>
        <xsl:when test="$nav">
          <a href="{$search_script}?{$search_url}&amp;start={$view_begin - $num_results - 1}" title="Go to previous page">&lt; Previous</a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$style != 'top'">
            <strong><xsl:call-template name="nbsp"/></strong>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$nav">
          <a href="{$search_script}?{$search_url}&amp;start={$view_begin + $num_results - 1}" title="Go to next page">Next &gt;</a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$style != 'top'">
            <strong><xsl:call-template name="nbsp"/></strong>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Google navigation bar in result page -->
<xsl:template name="google_navigation">
  <xsl:param name="prev"/>
  <xsl:param name="next"/>
  <xsl:param name="view_begin"/>
  <xsl:param name="view_end"/>
  <xsl:param name="guess"/>
  <xsl:param name="navigation_style"/>

  <!-- *** Should we even show navigation? *** -->
  <xsl:if test="$prev or $next">

  <xsl:if test="$navigation_style = 'top'">
    <p class="top_nav">
      <!-- *** Get previous navigation, if available *** -->
      <xsl:call-template name="nav_dir">
        <xsl:with-param name="style" select="$navigation_style"/>
        <xsl:with-param name="type" select="'prev'"/>
        <xsl:with-param name="nav" select="$prev"/>
        <xsl:with-param name="view_begin" select="$view_begin"/>
      </xsl:call-template>

      <xsl:if test="$prev and $next">
        <xsl:text> </xsl:text>
      </xsl:if>

      <!-- *** Get next navigation, if available *** -->
      <xsl:call-template name="nav_dir">
        <xsl:with-param name="style" select="$navigation_style"/>
        <xsl:with-param name="type" select="'next'"/>
        <xsl:with-param name="nav" select="$next"/>
        <xsl:with-param name="view_begin" select="$view_begin"/>
      </xsl:call-template>
    </p>
  </xsl:if>

  <xsl:if test="$navigation_style != 'top'">
    <div id="bottomnav">
      <p>
        <!-- *** Show previous navigation, if available *** -->
        <xsl:call-template name="nav_dir">
          <xsl:with-param name="style" select="$navigation_style"/>
          <xsl:with-param name="type" select="'prev'"/>
          <xsl:with-param name="nav" select="$prev"/>
          <xsl:with-param name="view_begin" select="$view_begin"/>
        </xsl:call-template>
        <xsl:if test="$prev">
          <xsl:text> </xsl:text>
        </xsl:if>

        <xsl:if test="($navigation_style = 'google') or ($navigation_style = 'link')">
          <!-- *** Google result set navigation *** -->
          <xsl:variable name="mod_end">
            <xsl:choose>
              <xsl:when test="$next"><xsl:value-of select="$guess"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="$view_end"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:call-template name="result_nav">
            <xsl:with-param name="start" select="0"/>
            <xsl:with-param name="end" select="$mod_end"/>
            <xsl:with-param name="current_view" select="($view_begin)-1"/>
            <xsl:with-param name="navigation_style" select="$navigation_style"/>
          </xsl:call-template>
        </xsl:if>

        <!-- *** Show next navigation, if available *** -->
        <xsl:call-template name="nav_dir">
          <xsl:with-param name="style" select="$navigation_style"/>
          <xsl:with-param name="type" select="'next'"/>
          <xsl:with-param name="nav" select="$next"/>
          <xsl:with-param name="view_begin" select="$view_begin"/>
        </xsl:call-template>
      </p>
    </div>
  </xsl:if>

  </xsl:if>
</xsl:template>

<!-- Helper templates for generating Google result navigation - only shows 10 sets up or down from current view -->
<xsl:template name="result_nav">
  <xsl:param name="start" select="'0'"/>
  <xsl:param name="end"/>
  <xsl:param name="current_view"/>
  <xsl:param name="navigation_style"/>

  <!-- *** Choose how to show this result set *** -->
  <xsl:choose>
    <xsl:when test="($start)&lt;(($current_view)-(10*($num_results)))">
    </xsl:when>
    <xsl:when test="(($current_view)&gt;=($start)) and
                    (($current_view)&lt;(($start)+($num_results)))">
      <strong><xsl:value-of select="(($start)div($num_results))+1"/></strong>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="page_num">
        <xsl:value-of select="(($start)div($num_results))+1"/>
      </xsl:variable>
      <a href="{$search_script}?{$search_url}&amp;start={$start}" title="Go to page {$page_num}"><xsl:value-of select="$page_num"/></a>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text> </xsl:text>

  <!-- *** Recursively iterate through result sets to display *** -->
  <xsl:if test="((($start)+($num_results))&lt;($end)) and
                ((($start)+($num_results))&lt;(($current_view)+
                (10*($num_results))))">
    <xsl:call-template name="result_nav">
      <xsl:with-param name="start" select="$start+$num_results"/>
      <xsl:with-param name="end" select="$end"/>
      <xsl:with-param name="current_view" select="$current_view"/>
      <xsl:with-param name="navigation_style" select="$navigation_style"/>
    </xsl:call-template>
  </xsl:if>

</xsl:template>

<!-- Top separation bar -->
<xsl:template name="top_sep_bar">
  <xsl:param name="text"/>
  <xsl:param name="show_info"/>
  <xsl:param name="time"/>

  <xsl:if test="$show_info != '0'">
    <xsl:if test="count(/GSP/RES/R)>0">
      <div id="resultinfo">
     		<p class="term_searched">Searched for '<strong><xsl:value-of select="$space_normalized_query"/></strong>'.</p>
        <p class="result_count">Results <strong><xsl:value-of select="RES/@SN"/></strong> - <strong><xsl:value-of select="RES/@EN"/></strong> of about <strong><xsl:value-of select="RES/M"/></strong>. Search took <strong><xsl:value-of select="round($time * 100.0) div 100.0"/></strong> seconds.</p>
    	</div>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- Utility functions for generating html entities -->
<xsl:template name="nbsp">
  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
</xsl:template>
<xsl:template name="nbsp3">
  <xsl:call-template name="nbsp"/>
  <xsl:call-template name="nbsp"/>
  <xsl:call-template name="nbsp"/>
</xsl:template>
<xsl:template name="nbsp4">
  <xsl:call-template name="nbsp3"/>
  <xsl:call-template name="nbsp"/>
</xsl:template>
<xsl:template name="quot">
  <xsl:text disable-output-escaping="yes">&amp;quot;</xsl:text>
</xsl:template>
<xsl:template name="copy">
  <xsl:text disable-output-escaping="yes">&amp;copy;</xsl:text>
</xsl:template>
<xsl:variable name="apos">'</xsl:variable>

<!-- Hidden field helper template -->
<xsl:template name="hidden_field">
  <xsl:param name="name"/>
  <xsl:variable name="n" select="substring-before($name, ',')"/>
  <xsl:if test="$name">
    <xsl:if test="PARAM[@name=$n]">
      <input type="hidden" name="{$n}" value="{PARAM[@name=$n]/@value}" />
    </xsl:if>
    <xsl:call-template name="hidden_field">
      <xsl:with-param name="name" select="substring-after($name, ',')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- Content-type helper template (do not customize) -->
<xsl:template name="content_type">
  <xsl:param name="name"/>
  <xsl:param name="value"/>
  <xsl:param name="charset"/>
  <xsl:param name="default" select="''"/>
  <xsl:variable name="v" select="substring-before($value, ',')"/>
  <xsl:variable name="c" select="substring-before($charset, ',')"/>
  <xsl:choose>
    <xsl:when test="$value">
      <xsl:choose>
        <xsl:when test="PARAM[(@name=$name) and (@value=$v)]">
          <meta http-equiv="content-type" content="application/xhtml+xml; charset={$c}"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="content_type">
            <xsl:with-param name="name" select="$name"/>
            <xsl:with-param name="value" select="substring-after($value, ',')"/>
            <xsl:with-param name="charset" select="substring-after($charset, ',')"/>
            <xsl:with-param name="default" select="$default"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <meta http-equiv="content-type" content="application/xhtml+xml; charset={$default}"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Utility functions -->
<!-- *** Find the substring after the last occurence of a separator *** -->
<xsl:template name="last_substring_after">
  <xsl:param name="string"/>
  <xsl:param name="separator"/>
  <xsl:param name="fallback"/>
  <xsl:variable name="newString" select="substring-after($string, $separator)"/>
  <xsl:choose>
    <xsl:when test="$newString!=''">
      <xsl:call-template name="last_substring_after">
        <xsl:with-param name="string" select="$newString"/>
        <xsl:with-param name="separator" select="$separator"/>
        <xsl:with-param name="fallback" select="$newString"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$fallback"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- *** Find and replace *** -->
<xsl:template name="replace_string">
  <xsl:param name="find"/>
  <xsl:param name="replace"/>
  <xsl:param name="string"/>
  <xsl:choose>
    <xsl:when test="contains($string, $find)">
      <xsl:value-of select="substring-before($string, $find)"/>
      <xsl:value-of select="$replace"/>
      <xsl:call-template name="replace_string">
        <xsl:with-param name="find" select="$find"/>
        <xsl:with-param name="replace" select="$replace"/>
        <xsl:with-param name="string" select="substring-after($string, $find)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- *** Escape quotes properly *** -->
<xsl:template name="escape_quot">
  <xsl:param name="string"/>
  <xsl:call-template name="replace_string">
    <xsl:with-param name="find" select="'&quot;'"/>
    <xsl:with-param name="replace" select="'&amp;quot;'"/>
    <xsl:with-param name="string" select="$string"/>
  </xsl:call-template>
</xsl:template>

<!-- *** URI Encode *** -->
<xsl:template name="uriencode">
  <xsl:param name="text"/>

  <xsl:param name="from" select="'% $ &amp; + , / : ; = ? @ '"/>
  <xsl:param name="to" select="'25 24 26 2B 2C 2F 3A 3B 3D 3F 40 '"/>
  <xsl:variable name="find" select="substring-before($from, ' ')"/>
  <xsl:variable name="replace" select="substring-before($to, ' ')"/>

  <xsl:choose>
    <xsl:when test="$find">
      <xsl:variable name="replaced">
        <xsl:call-template name="replace_string">
          <xsl:with-param name="find" select="$find"/>
          <xsl:with-param name="replace" select="concat('%', $replace)"/>
          <xsl:with-param name="string" select="$text"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:call-template name="uriencode">
        <xsl:with-param name="text" select="$replaced"/>
        <xsl:with-param name="from" select="substring-after($from, ' ')"/>
        <xsl:with-param name="to" select="substring-after($to, ' ')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="translate($text, ' ', '+')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Display error messages -->
<xsl:template name="error_page">
  <xsl:param name="errorMessage"/>
  <xsl:param name="errorDescription"/>

  <xsl:call-template name="top_sep_bar">
    <xsl:with-param name="text" select="Error"/>
    <xsl:with-param name="show_info" select="0"/>
    <xsl:with-param name="time" select="0"/>
  </xsl:call-template>

  <dl>
    <dt>Message:</dt>
    <dd><xsl:value-of select="$errorMessage"/></dd>
    <dt>Description:</dt>
    <dd><xsl:value-of select="$errorDescription"/></dd>
    <dt>Details:</dt>
    <dd><xsl:copy-of select="/"/></dd>
  </dl>
</xsl:template>

<!-- Swallow unmatched elements -->
<xsl:template match="@*|node()"/>
</xsl:stylesheet>
