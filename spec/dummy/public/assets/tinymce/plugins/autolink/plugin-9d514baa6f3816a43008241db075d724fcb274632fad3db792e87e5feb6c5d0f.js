tinymce.PluginManager.add("autolink",function(e){function t(e){i(e,-1,"(",!0)}function n(e){i(e,0,"",!0)}function r(e){i(e,-1,"",!1)}function i(e,t,n){function r(e,t){if(t<0&&(t=0),3==e.nodeType){var n=e.data.length;t>n&&(t=n)}return t}function i(e,t){1!=e.nodeType||e.hasChildNodes()?s.setStart(e,r(e,t)):s.setStartBefore(e)}function o(e,t){1!=e.nodeType||e.hasChildNodes()?s.setEnd(e,r(e,t)):s.setEndAfter(e)}var s,l,c,u,d,f,p,m,g,h;if("A"!=e.selection.getNode().tagName){if(s=e.selection.getRng(!0).cloneRange(),s.startOffset<5){if(m=s.endContainer.previousSibling,!m){if(!s.endContainer.firstChild||!s.endContainer.firstChild.nextSibling)return;m=s.endContainer.firstChild.nextSibling}if(g=m.length,i(m,g),o(m,g),s.endOffset<5)return;l=s.endOffset,u=m}else{if(u=s.endContainer,3!=u.nodeType&&u.firstChild){for(;3!=u.nodeType&&u.firstChild;)u=u.firstChild;3==u.nodeType&&(i(u,0),o(u,u.nodeValue.length))}l=1==s.endOffset?2:s.endOffset-1-t}c=l;do i(u,l>=2?l-2:0),o(u,l>=1?l-1:0),l-=1,h=s.toString();while(" "!=h&&""!==h&&160!=h.charCodeAt(0)&&l-2>=0&&h!=n);s.toString()==n||160==s.toString().charCodeAt(0)?(i(u,l),o(u,c),l+=1):0===s.startOffset?(i(u,0),o(u,c)):(i(u,l),o(u,c)),f=s.toString(),"."==f.charAt(f.length-1)&&o(u,c-1),f=s.toString(),p=f.match(a),p&&("www."==p[1]?p[1]="http://www.":/@$/.test(p[1])&&!/^mailto:/.test(p[1])&&(p[1]="mailto:"+p[1]),d=e.selection.getBookmark(),e.selection.setRng(s),e.execCommand("createlink",!1,p[1]+p[2]),e.settings.default_link_target&&e.dom.setAttrib(e.selection.getNode(),"target",e.settings.default_link_target),e.selection.moveToBookmark(d),e.nodeChanged())}}var o,a=/^(https?:\/\/|ssh:\/\/|ftp:\/\/|file:\/|www\.|(?:mailto:)?[A-Z0-9._%+\-]+@)(.+)$/i;return e.settings.autolink_pattern&&(a=e.settings.autolink_pattern),e.on("keydown",function(t){if(13==t.keyCode)return r(e)}),tinymce.Env.ie?void e.on("focus",function(){if(!o){o=!0;try{e.execCommand("AutoUrlDetect",!1,!0)}catch(e){}}}):(e.on("keypress",function(n){if(41==n.keyCode)return t(e)}),void e.on("keyup",function(t){if(32==t.keyCode)return n(e)}))});
