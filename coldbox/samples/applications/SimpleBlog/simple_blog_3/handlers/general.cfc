<!-----------------------------------------------------------------------Author 	 :	Henrik JoretegDate     :	October, 2008Description : 				This is a ColdBox event handler for general methods.Please note that the extends needs to point to the eventhandler.cfcin the ColdBox system directory.extends = coldbox.system.EventHandler	-----------------------------------------------------------------------><cfcomponent name="general" extends="coldbox.system.EventHandler" output="false" autowire="true">	<!--- Dependencies --->	<cfproperty name="EntryService" 	type="model:EntryService" 		scope="instance" />	<cfproperty name="CommentService" 	type="model:CommentService" 	scope="instance" />	<cfproperty name="RSSService" 		type="model:RSSService" 		scope="instance" />	<!----------------------------------- CONSTRUCTOR --------------------------------------->				<cffunction name="init" access="public" returntype="any" output="false" hint="constructor">		<cfargument name="controller" type="any">		<cfset super.init(arguments.controller)>		<!--- Any constructor code here --->				<cfreturn this>	</cffunction>	<!----------------------------------- PUBLIC EVENTS --------------------------------------->		<cffunction name="index" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfscript>			/* Welcome message */			Event.setValue("welcomeMessage","Hello, welcome to Simple Blog!");			/* Display View */			Event.setView("home");		</cfscript>	</cffunction>		<!--- about --->	<cffunction name="about" access="public" returntype="void" output="false" hint="">		<cfargument name="Event" type="any" required="yes">	    <cfset var rc = event.getCollection()>	    <!--- Display View --->    			<cfset Event.setView("about")>	</cffunction>		<!--- blog --->
	<cffunction name="blog" access="public" returntype="void" output="false" hint="Displays the blog page" cache="true" cachetimeout="30" >
		<cfargument name="Event" type="any" required="yes">
	    <cfset var rc = event.getCollection()>
	    	    <cfscript>	    	rc.posts = instance.EntryService.getLatestEntries();	    	Event.setView("blog");	    </cfscript>
	     
	</cffunction>		<!--- newPost --->
	<cffunction name="newPost" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="any" required="yes">
	    <cfset var rc = event.getCollection()>
	        	    <cfset Event.setView("newPost")>
	     
	</cffunction>			<!--- doNewPost --->	<cffunction name="doNewPost" access="public" returntype="void" output="false" hint="Action to handle new post operation">		<cfargument name="Event" type="any" required="yes">	    <cfset var rc = event.getCollection()>	    <cfset var newPost = "">	    <cfscript>	    	/* Get new post from service layer */	    	newPost = instance.EntryService.getEntry();	    	/* Populate Post */	    	getPlugin("BeanFactory").populateBean(newPost);	    	/* Save post */	    	instance.EntryService.saveEntry(newPost);	    	/* Clear events */	    	getColdboxOcm().clearEvent("general.blog");	    	/* Re-Route */	    	setNextRoute("general/blog");	    		    </cfscript>    	     	</cffunction>		<!--- viewPost --->	<cffunction name="viewPost" access="public" returntype="void" output="false" hint="Shows one particular post and related comments" cache="true" cacheTimeout="10">		<cfargument name="Event" type="any" required="yes">	    <cfscript>	    	var rc = event.getCollection();	    	/* Get the entry */	    	rc.oPost = instance.EntryService.getEntry(rc.id);	    	/* Get Comments */	    	rc.comments = instance.CommentService.getComments(rc.id);	    	/* Set view to render */	    	Event.setView('viewPost');	    </cfscript>       	</cffunction>	<!--- doAddComment --->	<cffunction name="doAddComment" access="public" returntype="void" output="false" hint="action that adds comment">		<cfargument name="Event" type="any" required="yes">	    <cfscript>			var rc = event.getCollection();			var newComment = "";			/* new comment */			newComment = instance.CommentService.getComment();			/* Populate */			newComment.setComment(rc.commentField);		    newComment.setParentEntry(instance.EntryService.getEntry(rc.id));			/* Save Comment */			instance.CommentService.saveComment(newComment);			/* Clear Events from cache */			getColdboxOCM().clearEvent("general.viewPost","id=#rc.id#");						/* ReRoute */			setNextRoute("general/viewPost/" & rc.ID);		</cfscript>    	</cffunction>	<!--- This was my attempt at abstracting this out to a RSSService --->	<cffunction name="rss" access="public" returntype="void" output="false" hint="Displays rss feed of entries.">		<cfargument name="Event" type="any" required="yes">				<cfscript>			var feedStruct = instance.RSSService.getFullRSS();			var plugin = getPlugin("FeedGenerator");			var columnMap = StructNew();						/* Use the columnmapper */			columnMap.title = "title";			columnMap.description = "entryBody";			columnMap.pubDate = "time";			columnMap.link = "link";						/* Verify the Feed first */			plugin.verifyFeed(feedStruct,columnMap);			/* Create the Feed */			feed = plugin.createFeed(feedStruct,columnMap);			/* Render Data baby */			Event.renderData(type="PLAIN", data=feed);		</cfscript>	       	</cffunction>	</cfcomponent>