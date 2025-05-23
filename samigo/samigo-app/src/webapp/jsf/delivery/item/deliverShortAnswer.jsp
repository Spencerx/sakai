<%-- $Id$
include file for delivering short answer essay questions
should be included in file importing DeliveryMessages
--%>
<!--
* $Id$
<%--
***********************************************************************************
*
* Copyright (c) 2004, 2005, 2006 The Sakai Foundation.
*
* Licensed under the Educational Community License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.osedu.org/licenses/ECL-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License. 
*
**********************************************************************************/
--%>
-->

<h:outputText value="#{question.text}"  escape="false">
  <f:converter converterId="org.sakaiproject.tool.assessment.jsf.convert.SecureContentWrapper" />
</h:outputText>

<!-- ATTACHMENTS -->
<%@ include file="/jsf/delivery/item/attachment.jsp" %>

<h:panelGrid rendered="#{!(delivery.actionString=='reviewAssessment' || delivery.actionString=='gradeAssessment')}">
<f:verbatim><br/></f:verbatim>
<h:outputText value="#{deliveryMessages.maxSAText}"/>
</h:panelGrid>

<h:outputText value="#{deliveryMessages.sa_invalid_length_error} " escape="false" rendered="#{question.isInvalidSALengthInput}" styleClass="sak-banner-error"/>

<f:verbatim><input type="hidden" id="ckeditor-autosave-context" name="ckeditor-autosave-context" value="samigo_deliverShortAnswer" /></f:verbatim>
<h:panelGroup rendered="#{question.itemData.itemId!=null}"><f:verbatim><input type="hidden" id="ckeditor-autosave-entity-id" name="ckeditor-autosave-entity-id" value="</f:verbatim><h:outputText value="#{question.itemData.itemId}"/><f:verbatim>"/></f:verbatim></h:panelGroup>

<h:panelGrid rendered="#{delivery.actionString!='reviewAssessment'
            && delivery.actionString!='gradeAssessment'}">
	<samigo:wysiwyg rows="240" value="#{question.responseText}" hasToggle="yes" maxCharCount="32000">
	</samigo:wysiwyg>
</h:panelGrid>

<h:outputText value="#{question.responseTextForDisplay}" 
   rendered="#{delivery.actionString=='reviewAssessment'
            || delivery.actionString=='gradeAssessment'}" escape="false"/>

<f:verbatim><br /></f:verbatim>
<h:panelGroup rendered="#{(delivery.actionString=='previewAssessment'
                || delivery.actionString=='takeAssessment' 
                || delivery.actionString=='takeAssessmentViaUrl')
             && delivery.navigation ne '1' && delivery.displayMardForReview }">
<h:selectBooleanCheckbox value="#{question.review}" id="mark_for_review" />
	<h:outputLabel for="mark_for_review" value="#{deliveryMessages.mark}" />
	<h:outputLink title="#{assessmentSettingsMessages.whats_this_link}" value="#" onclick="javascript:window.open('/samigo-app/jsf/author/markForReviewPopUp.faces','MarkForReview','width=350,height=280,scrollbars=yes, resizable=yes');event.preventDefault();" >
		<h:outputText value=" #{assessmentSettingsMessages.whats_this_link}"/>
	</h:outputLink>
</h:panelGroup>

<f:verbatim><br /></f:verbatim>


<h:panelGroup rendered="#{delivery.feedback eq 'true'}">
  <h:panelGrid rendered="#{((delivery.feedbackComponent.showCorrectResponse && delivery.feedbackComponent.showCorrection && !delivery.noFeedback=='true' && question.modelAnswerIsNotEmpty) || (delivery.actionString=='gradeAssessment' && question.modelAnswerIsNotEmpty))}" >
    <h:panelGroup> 
      <h:outputLabel for="modelSC" styleClass="answerkeyFeedbackCommentLabel" value="#{deliveryMessages.model}" />
      <h:outputText id="modelSC" value=" #{question.key} " escape="false"/>
    </h:panelGroup> 
    <h:outputText value=" "/>
  </h:panelGrid>
  
  <h:panelGrid rendered="#{delivery.feedbackComponent.showItemLevel && !delivery.noFeedback=='true' && question.feedbackIsNotEmpty}">
    <h:panelGroup> 
      <h:outputLabel for="feedSC" styleClass="answerkeyFeedbackCommentLabel" value="#{commonMessages.feedback}#{deliveryMessages.column}" />
      <h:outputText id="feedSC" value=" #{question.feedback} " escape="false" />
    </h:panelGroup> 
    <h:outputText value=" "/>
  </h:panelGrid>
  
  <h:panelGrid rendered="#{delivery.actionString !='gradeAssessment' && delivery.feedbackComponent.showGraderComment && !delivery.noFeedback=='true' && (question.gradingCommentIsNotEmpty || question.hasItemGradingAttachment)}" columns="1" border="0">
    <h:panelGroup>  
      <h:outputLabel for="commentSC" styleClass="answerkeyFeedbackCommentLabel" value="#{deliveryMessages.comment}#{deliveryMessages.column} " />
	  <h:outputText id="commentSC" value="#{question.gradingComment}" escape="false" rendered="#{question.gradingCommentIsNotEmpty}"/>
    </h:panelGroup>
    
	<h:panelGroup rendered="#{question.hasItemGradingAttachment}">
      <h:dataTable value="#{question.itemGradingAttachmentList}" var="attach">
        <h:column>
          <%@ include file="/jsf/shared/mimeicon.jsp" %>
        </h:column>
        <h:column>
          <f:verbatim>&nbsp;&nbsp;&nbsp;&nbsp;</f:verbatim>
          <h:outputLink value="#{attach.location}" target="new_window">
            <h:outputText value="#{attach.filename}" />
          </h:outputLink>
        </h:column>
        <h:column>
          <f:verbatim>&nbsp;&nbsp;&nbsp;&nbsp;</f:verbatim>
          <h:outputText escape="false" value="(#{attach.fileSize} #{generalMessages.kb})" rendered="#{!attach.isLink}"/>
        </h:column>
      </h:dataTable>
    </h:panelGroup>
  </h:panelGrid>
</h:panelGroup>
