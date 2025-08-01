<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://www.sakaiproject.org/samigo" prefix="samigo" %>
<%@ taglib uri="http://sakaiproject.org/jsf2/sakai" prefix="sakai" %>
<%@ taglib uri="http://myfaces.apache.org/tomahawk" prefix="t"%>
<!DOCTYPE html
     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
<!--
$Id$
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
 <f:view>
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
      <head><%= request.getAttribute("html.head") %>
      <title><h:outputText value="#{evaluationMessages.title_question}" /></title>
      <script src="/samigo-app/js/authoringQuestionCancellation.js"></script>
      <script type="module" src="/webcomponents/bundles/rubric-association-requirements.js<h:outputText value="#{questionScores.CDNQuery}" />"></script>
      </head>
      <body onload="<%= request.getAttribute("html.body.onload") %>">

 <!-- JAVASCRIPT -->
<%@ include file="/js/delivery.js" %>

<script>
  $(document).ready(function(){
    // The current class is assigned using Javascript because we don't use facelets and the include directive does not support parameters.
    var currentLink = $('#editTotalResults\\:questionScoresMenuLink');
    currentLink.addClass('current');
    // Remove the link of the current option
    currentLink.html(currentLink.find('a').text());
  });

  function toPoint(id) {

    var x = document.getElementById(id).value;
    document.getElementById(id).value = x.replace(',', '.');
  }

  function downloadAll(url) {
	window.location = url;
  }

  function initRubricDialogWrapper(gradingId) {

    initRubricDialog(gradingId
      , <h:outputText value="'#{evaluationMessages.done}'"/>
      , <h:outputText value="'#{evaluationMessages.cancel}'"/>
      , <h:outputText value="'#{evaluationMessages.saverubricgrading}'"/>
      , <h:outputText value="'#{evaluationMessages.unsavedchangesrubric}'"/>);
  }
</script>
<!-- content... -->
<div class="portletBody container-fluid">
<h:form id="editTotalResults">
  <h:inputHidden id="publishedId" value="#{questionScores.publishedId}" />
  <h:inputHidden id="itemId" value="#{questionScores.itemId}" />

  <!-- HEADINGS -->
  <%@ include file="/jsf/evaluation/evaluationHeadings.jsp" %>

  <h:panelGroup layout="block" styleClass="page-header">
    <h1>
      <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{questionScores.itemName} " escape="false"/>
      <small><h:outputText value="(#{totalScores.assessmentName}) " escape="false"/></small>
    </h1>
  </h:panelGroup>

  <!-- EVALUATION SUBMENU -->
  <%@ include file="/jsf/evaluation/evaluationSubmenu.jsp" %>

<div class="tier1">
  <h:messages styleClass="sak-banner-error" rendered="#{! empty facesContext.maximumSeverity}" layout="table"/>
  
  <h:dataTable value="#{questionScores.sections}" var="partinit">
    <h:column>
      <h:outputText value="#{evaluationMessages.part} #{partinit.partNumber}#{evaluationMessages.column}" />
    </h:column>
    <h:column>
      <samigo:dataLine value="#{partinit.questionNumberList}" var="iteminit" separator=" | " first="0" rows="#{partinit.questionNumberListSize}" rendered="#{!partinit.isRandomDrawPart && !partinit.isFixedRandomDrawPart}" >
        <h:column>
          <h:commandLink title="#{evaluationMessages.t_questionScores}" action="questionScores" immediate="true" styleClass="#{iteminit.itemCancelled ? 'cancelled-question-link' : ''}">
            <h:outputText value="#{evaluationMessages.q}#{iteminit.partNumber} " escape="false"/>
			<f:actionListener
              type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScorePagerListener" />
            <f:actionListener
              type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
            <f:param name="newItemId" value="#{iteminit.id}" />
          </h:commandLink>
	    </h:column>
      </samigo:dataLine>

	  <h:outputFormat value="#{evaluationMessages.random_draw_info}" rendered="#{partinit.isRandomDrawPart}">
	  	<f:param value="#{partinit.numberQuestionsDraw}" />
		<f:param value="#{partinit.numberQuestionsTotal}" />
	  </h:outputFormat>

	  <h:outputFormat value="#{evaluationMessages.fixed_random_draw_info}" rendered="#{partinit.isFixedRandomDrawPart}">
	  	<f:param value="#{partinit.numberQuestionsFixed}" />
	  	<f:param value="#{partinit.numberQuestionsDraw}" />
		<f:param value="#{partinit.numberQuestionsTotal}" />
	  </h:outputFormat>

	  <samigo:dataLine value="#{partinit.questionNumberList}" var="iteminit" separator=" | " first="0" rows="#{partinit.questionNumberListSize}" rendered="#{partinit.isRandomDrawPart || partinit.isFixedRandomDrawPart}" >
        <h:column>
          <h:commandLink title="#{evaluationMessages.t_questionScores}" action="questionScores" immediate="true" styleClass="#{iteminit.itemCancelled ? 'cancelled-question-link' : ''}">
            <h:outputText value="#{evaluationMessages.q}#{iteminit.partNumber} "/>
			<f:actionListener
              type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScorePagerListener" />
            <f:actionListener
              type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
            <f:param name="newItemId" value="#{iteminit.id}" />
          </h:commandLink>
	    </h:column>
      </samigo:dataLine>

	  <h:outputText value="#{evaluationMessages.no_questions} " rendered="#{partinit.noQuestions}"/>
    </h:column>
  </h:dataTable>

  <t:dataList value="#{questionScores.deliveryItem}" var="question">
    <div class="page-header">
      <h2>
     <h:panelGroup rendered="#{questionScores.typeId == '7'}">
         <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}" />
         <small>
           <h:outputText value=" - #{evaluationMessages.q_aud} (#{questionScores.maxPoint})"/>
         </small>
     </h:panelGroup>
     <h:panelGroup rendered="#{questionScores.typeId == '6'}">
         <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}" />
         <small>
         <h:outputText value=" - #{evaluationMessages.q_fu} (#{questionScores.maxPoint})"/>
         </small>
     </h:panelGroup>
     <h:panelGroup rendered="#{questionScores.typeId == '8'}">
         <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}" />
         <small>
         <h:outputText value=" - #{evaluationMessages.q_fib} (#{questionScores.maxPoint})"/>
         </small>
     </h:panelGroup>
     <h:panelGroup rendered="#{questionScores.typeId == '11'}">
         <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}" />
         <small>
         <h:outputText value=" - #{evaluationMessages.q_fin} (#{questionScores.maxPoint})"/>
         </small>
     </h:panelGroup>
      <h:panelGroup rendered="#{questionScores.typeId == '9'}">
         <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}" />
         <small>
         <h:outputText value=" - #{evaluationMessages.q_match} (#{questionScores.maxPoint})"/>
         </small>
     </h:panelGroup>
     <h:panelGroup rendered="#{questionScores.typeId == '2'}">
         <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}" />
         <small>
         <h:outputText value=" - #{commonMessages.multipl_mc_ms} (#{questionScores.maxPoint})"/>
         </small>
     </h:panelGroup>
     <h:panelGroup rendered="#{questionScores.typeId == '4'}">
         <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}" />
         <small>
         <h:outputText value=" - #{evaluationMessages.q_tf} (#{questionScores.maxPoint})"/>
         </small>
     </h:panelGroup>
     <h:panelGroup rendered="#{questionScores.typeId == '5'}">
         <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}" />
         <small>
         <h:outputText value=" - #{evaluationMessages.q_short_ess} (#{questionScores.maxPoint})"/>
         </small>
     </h:panelGroup>
     <h:panelGroup rendered="#{questionScores.typeId == '3'}">
         <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}" />
         <small>
         <h:outputText value=" - #{evaluationMessages.q_mult_surv} (#{questionScores.maxPoint})"/>
         </small>
     </h:panelGroup>
     <h:panelGroup rendered="#{questionScores.typeId == '13'}">
         <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}"/>
         <small>
             <h:outputText value=" - #{evaluationMessages.q_matrix_choices_surv} (#{questionScores.maxPoint})"/>
         </small>
     </h:panelGroup>
     <h:panelGroup rendered="#{questionScores.typeId == '1'}">
         <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}" />
         <small>
         <h:outputText value=" - #{commonMessages.multiple_choice_sin} (#{questionScores.maxPoint})"/>
         </small>
     </h:panelGroup>
     <h:panelGroup rendered="#{questionScores.typeId == '12'}">
		 <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}" />
         <small>
         <h:outputText value=" - #{commonMessages.multipl_mc_ss} (#{questionScores.maxPoint})"/>
         </small>
     </h:panelGroup>
	 <h:panelGroup rendered="#{questionScores.typeId == '16'}"><!-- // IMAGEMAP_QUESTION -->
		 <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}" />
         <small>
		 <h:outputText value=" - #{evaluationMessages.q_imq} (#{questionScores.maxPoint})"/>
         </small>
      </h:panelGroup>
    <h:panelGroup rendered="#{questionScores.typeId == '14'}">
      <h:outputText value="#{evaluationMessages.question}#{question.sequence} - #{evaluationMessages.q_emi}"/>
    </h:panelGroup>   
    <h:panelGroup rendered="#{questionScores.typeId == '15'}"><!-- // CALCULATED_QUESTION -->
      <h:outputText value="#{evaluationMessages.part} #{questionScores.partName}#{evaluationMessages.column} #{evaluationMessages.question} #{question.sequence}"/>
      <small>
          <h:outputText value=" - #{evaluationMessages.q_cq} (#{questionScores.maxPoint})"/>
      </small>
    </h:panelGroup>
     <h:panelGroup rendered="#{question.isExtraCredit == true}">
        <h:outputText styleClass="extraCreditLabel" value=" #{deliveryMessages.extra_credit_preview}" />
     </h:panelGroup>
     <h:panelGroup styleClass="d-none d-sm-inline small" rendered="#{question.minScore > 0 || question.discount > 0}">
        <h:outputText value=" (" />
        <h:outputText value="#{authorMessages.answer_min_point_short}: #{question.minScore}" rendered="#{question.minScore > 0}" />
        <h:outputText value=", " rendered="#{question.minScore > 0 && question.discount > 0}" />
        <h:outputText value="#{authorMessages.answer_discount_point_short}: #{question.discount}" rendered="#{question.discount > 0}" />
        <h:outputText value=")" />
      </h:panelGroup>
      </h2>
    </div>
  </t:dataList>

  <t:dataList value="#{questionScores.deliveryItem}" var="question">
  <h:panelGroup styleClass="samigo-question-callout#{question.cancellation != 0 ? ' samigo-question-cancelled' : ''}" layout="block">
  <div id="questionScoreItemAttachments">
      <%@ include file="/jsf/evaluation/questionScoreItemAttachment.jsp" %>
  </div>
  <h:panelGroup rendered="#{questionScores.typeId == '7'}">
    <f:subview id="displayAudioRecording">
      <%@ include file="/jsf/evaluation/item/displayAudioRecordingQuestion.jsp" %>
    </f:subview>
  </h:panelGroup>
  <h:panelGroup rendered="#{questionScores.typeId == '6'}">
    <f:subview id="displayFileUpload">
    <%@ include file="/jsf/evaluation/item/displayFileUploadQuestion.jsp" %>
    </f:subview>
  </h:panelGroup>
    <h:panelGroup rendered="#{questionScores.typeId == '11'}">
      <f:subview id="displayFillInNumeric">
      <%@ include file="/jsf/evaluation/item/displayFillInNumeric.jsp" %>
      </f:subview>
  </h:panelGroup>
  <h:panelGroup rendered="#{questionScores.typeId == '8'}">
    <f:subview id="displayFillInTheBlank">
    <%@ include file="/jsf/evaluation/item/displayFillInTheBlank.jsp" %>
    </f:subview>
  </h:panelGroup>
  <h:panelGroup rendered="#{questionScores.typeId == '9'}">
    <f:subview id="displayMatching">
    <%@ include file="/jsf/evaluation/item/displayMatching.jsp" %>
    </f:subview>
  </h:panelGroup>
  <h:panelGroup rendered="#{questionScores.typeId == '2'}">
    <f:subview id="displayMultipleChoiceMultipleCorrect">
  <%@ include file="/jsf/evaluation/item/displayMultipleChoiceMultipleCorrect.jsp" %>
    </f:subview>
  </h:panelGroup>
  <h:panelGroup
    rendered="#{questionScores.typeId == '1' || questionScores.typeId == '12' ||
                questionScores.typeId == '3'}">
    <f:subview id="displayMultipleChoiceSingleCorrect">
    <%@ include file="/jsf/evaluation/item/displayMultipleChoiceSingleCorrect.jsp" %>
    </f:subview>
  </h:panelGroup>
  <h:panelGroup rendered="#{questionScores.typeId == '5'}">
    <f:subview id="displayShortAnswer">
   <%@ include file="/jsf/evaluation/item/displayShortAnswer.jsp" %>
    </f:subview>
  </h:panelGroup>
  <h:panelGroup rendered="#{questionScores.typeId == '4'}">
    <f:subview id="displayTrueFalse">
    <%@ include file="/jsf/evaluation/item/displayTrueFalse.jsp" %>
    </f:subview>
  </h:panelGroup>
  <h:panelGroup rendered="#{questionScores.typeId == '14'}">
    <f:subview id="displayExtendedMatchingItems">
    <%@ include file="/jsf/evaluation/item/displayExtendedMatchingItems.jsp" %>
    </f:subview>
  </h:panelGroup>
  <h:panelGroup rendered="#{questionScores.typeId == '13'}">
    <f:subview id="displayMatrixSurvey">
    <%@ include file="/jsf/evaluation/item/displayMatrixSurvey.jsp" %>
    </f:subview>
  </h:panelGroup>
  <h:panelGroup rendered="#{questionScores.typeId == '15'}"><!-- // CALCULATED_QUESTION -->
    <f:subview id="calculatedQuestion">
    <%@ include file="/jsf/evaluation/item/displayCalculatedQuestion.jsp" %>
    </f:subview>
  </h:panelGroup>
  <h:panelGroup rendered="#{questionScores.typeId == '16'}"><!-- // IMAGEMAP_QUESTION -->
    <f:subview id="imageMapQuestion">
    <%@ include file="/jsf/evaluation/item/displayImageMapQuestion.jsp" %>
    </f:subview>
  </h:panelGroup>
  <h:panelGroup styleClass="sak-banner-info" rendered="#{question.cancellation != 0}" layout="block">
    <h:outputText value="#{commonMessages.cancel_question_info_cancelled_question}" />
  </h:panelGroup>
  </h:panelGroup>
  <h:panelGroup rendered="#{question.cancellation == 0 && questionScores.cancellationAllowed}">
    <button class="button" data-item-cancellable="true" data-itemId='<h:outputText value="#{question.itemIdString}" />'>
      <h:outputText value="#{commonMessages.cancel_question}" />
    </button>
  </h:panelGroup>
  <h:panelGroup styleClass="sak-banner-info" rendered="#{questionScores.randomItemPresent}" layout="block">
    <h:outputText value="#{commonMessages.cancel_question_info_random} " />
  </h:panelGroup>
  </t:dataList>

  <h2>
    <p class="navView navModeAction">
      <h:outputText value="#{evaluationMessages.responses}"/>
    </p>
  </h2>

  <sakai:flowState bean="#{questionScores}" />

  <h:panelGroup styleClass="row score-box" layout="block" rendered="#{totalScores.anonymous eq 'false'}">

  <h:panelGroup styleClass="col-md-6" layout="block">
    <h:panelGroup styleClass="form-group" layout="block">
        <h:outputLabel styleClass="col-md-2" value="#{evaluationMessages.view}" />
        <h:outputText value="&#160;" escape="false" />
        <h:selectOneMenu value="#{questionScores.allSubmissions}" id="allSubmissionsL1"
         required="true" onchange="document.forms[0].submit();" rendered="#{totalScores.scoringOption eq '2'  && totalScores.multipleSubmissionsAllowed eq 'true'  }">
          <f:selectItem itemValue="3" itemLabel="#{evaluationMessages.all_sub}" />
          <f:selectItem itemValue="2" itemLabel="#{evaluationMessages.last_sub}" />
          <f:valueChangeListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        </h:selectOneMenu>
        <h:selectOneMenu value="#{questionScores.allSubmissions}" id="allSubmissionsH1"
         required="true" onchange="document.forms[0].submit();" rendered="#{totalScores.scoringOption eq '1'  && totalScores.multipleSubmissionsAllowed eq 'true' }">
          <f:selectItem itemValue="3" itemLabel="#{evaluationMessages.all_sub}" />
          <f:selectItem itemValue="1" itemLabel="#{evaluationMessages.highest_sub}" />
          <f:valueChangeListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        </h:selectOneMenu>
    
    <h:panelGroup layout="block" 
                  rendered="#{(questionScores.typeId == '1' || questionScores.typeId == '2' || 
                                 questionScores.typeId == '12' || questionScores.typeId == '4'  || questionScores.typeId == '5')}">
        <h:outputLabel value="&nbsp;#{evaluationMessages.with}&nbsp;" escape="false" />
        <h:selectOneMenu value="#{questionScores.selectedSARationaleView}" id="inlinepopup1"
            required="true" onchange="document.forms[0].submit();" >
            <f:selectItem itemValue="1" itemLabel="#{evaluationMessages.responses_popup}" />
            <f:selectItem itemValue="2" itemLabel="#{evaluationMessages.responses_inline}" />
            <f:valueChangeListener type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        </h:selectOneMenu>
    </h:panelGroup>
    
    <!-- SECTION AWARE -->
        <h:outputLabel value="&nbsp;#{evaluationMessages.forAllSectionsGroups}&nbsp;" escape="false" 
                        rendered="#{totalScores.availableSectionSize < 1}"/>
        <h:outputLabel value="&nbsp;#{evaluationMessages.for_s}&nbsp;" rendered="#{totalScores.availableSectionSize >= 1}" 
                        escape="false"/>

        <h:panelGroup layout="block" rendered="#{totalScores.availableSectionSize >= 1}">
            <h:selectOneMenu value="#{questionScores.selectedSectionFilterValue}" id="sectionpicker" required="true" 
                    onchange="document.forms[0].submit();" >
            <f:selectItems value="#{totalScores.sectionFilterSelectItems}"/>
            <f:valueChangeListener
            type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener"/>
            </h:selectOneMenu>
        </h:panelGroup>

      <h:panelGroup styleClass="form-group" rendered="#{questionScores.typeId == '6'}" layout="block">
        <h:outputLink styleClass="btn btn-default" title="#{evaluationMessages.download_responses}"  value="/samigo-app/servlet/DownloadAllMedia?publishedId=#{questionScores.publishedId}&publishedItemId=#{questionScores.itemId}&createdBy=#{question.itemData.createdBy}&partNumber=#{part.partNumber}&anonymous=#{totalScores.anonymous}&scoringType=#{questionScores.allSubmissions}">
          <h:outputText value="#{evaluationMessages.download_responses}"/>
        </h:outputLink>
      </h:panelGroup>

    </h:panelGroup>

        <h:panelGroup styleClass="samigo-search-student form-group" layout="block">
            <h:outputLabel styleClass="col-md-2" value="#{evaluationMessages.search}"/>
            <h:outputText value="&#160;" escape="false" />
            <h:inputText
                    id="searchString"
                    value="#{questionScores.searchString}"
                    onfocus="clearIfDefaultString(this, '#{evaluationMessages.search_default_student_search_string}')"
                    onkeypress="return submitOnEnter(event, 'editTotalResults:searchSubmitButton');"/>
            <h:outputText value="&nbsp;" escape="false" />
            <h:commandButton actionListener="#{questionScores.search}" value="#{evaluationMessages.search_find}" id="searchSubmitButton" />
            <h:outputText value="&nbsp;" escape="false" />
            <h:commandButton actionListener="#{questionScores.clear}" value="#{evaluationMessages.search_clear}"/>
         </h:panelGroup>
    </h:panelGroup>

    <h:panelGroup layout="block" styleClass="samigo-pager col-md-6" style="text-align: right">
        <sakai:pager id="pager1" totalItems="#{questionScores.dataRows}" firstItem="#{questionScores.firstRow}" pageSize="#{questionScores.maxDisplayedRows}" textStatus="#{evaluationMessages.paging_status}" >
            <f:valueChangeListener type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScorePagerListener" />
        </sakai:pager>
    </h:panelGroup>
  </h:panelGroup>

<h:panelGrid columns="3" columnClasses="samLeftNav,samRightNav" width="100%" rendered="#{totalScores.anonymous eq 'true'}">
  <h:panelGroup>
      <h:outputText value="#{evaluationMessages.view}" rendered="#{totalScores.multipleSubmissionsAllowed eq 'true' || (questionScores.typeId == '1' || questionScores.typeId == '2' || questionScores.typeId == '12' || questionScores.typeId == '4'  || questionScores.typeId == '5')}"/>
      <h:panelGroup styleClass="all-submissions" layout="block">
        <h:selectOneMenu value="#{questionScores.allSubmissions}" id="allSubmissionsL2"
         required="true" onchange="document.forms[0].submit();" rendered="#{totalScores.scoringOption eq '2'  && totalScores.multipleSubmissionsAllowed eq 'true' }">
        <f:selectItem itemValue="3" itemLabel="#{evaluationMessages.all_sub}" />
        <f:selectItem itemValue="2" itemLabel="#{evaluationMessages.last_sub}" />
        <f:valueChangeListener
         type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        </h:selectOneMenu>

        <h:selectOneMenu value="#{questionScores.allSubmissions}" id="allSubmissionsH2"
         required="true" onchange="document.forms[0].submit();" rendered="#{totalScores.scoringOption eq '1'  && totalScores.multipleSubmissionsAllowed eq 'true' }">
          <f:selectItem itemValue="3" itemLabel="#{evaluationMessages.all_sub}" />
          <f:selectItem itemValue="1" itemLabel="#{evaluationMessages.highest_sub}" />
          <f:valueChangeListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        </h:selectOneMenu>
        
        <h:outputText value="&nbsp;" escape="false" rendered="#{totalScores.multipleSubmissionsAllowed eq 'true'}"/>

        <h:outputText value="&nbsp;#{evaluationMessages.with}&nbsp;&nbsp;" escape="false" 
        	rendered="#{totalScores.multipleSubmissionsAllowed eq 'true' && (questionScores.typeId == '1' || questionScores.typeId == '2' || questionScores.typeId == '12' || questionScores.typeId == '4'  || questionScores.typeId == '5')}"/>
        
		<h:selectOneMenu value="#{questionScores.selectedSARationaleView}" id="inlinepopup2" 
         rendered="#{(questionScores.typeId == '1' || questionScores.typeId == '2' || questionScores.typeId == '12' || questionScores.typeId == '4'  || questionScores.typeId == '5')}" 
       	 required="true" onchange="document.forms[0].submit();" >
           <f:selectItem itemValue="1" itemLabel="#{evaluationMessages.responses_popup}" />
           <f:selectItem itemValue="2" itemLabel="#{evaluationMessages.responses_inline}" />
           <f:valueChangeListener type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        </h:selectOneMenu> 

      </h:panelGroup>

      <h:outputText value="&nbsp;#{evaluationMessages.separator}&nbsp;&nbsp;" style="color: #999999;" rendered="#{questionScores.typeId == '6'}" escape="false"/>
      <h:outputText value="&nbsp;" rendered="#{questionScores.typeId != '6'}" escape="false"/>
        
      <h:outputLink styleClass="btn btn-default" title="#{evaluationMessages.t_fileUpload}" rendered="#{questionScores.typeId == '6'}" value="/samigo-app/servlet/DownloadAllMedia?publishedId=#{questionScores.publishedId}&publishedItemId=#{questionScores.itemId}&createdBy=#{question.itemData.createdBy}&partNumber=#{part.partNumber}&anonymous=#{totalScores.anonymous}&scoringType=#{questionScores.allSubmissions}">
        <h:outputText value="#{evaluationMessages.download_responses}"/>
      </h:outputLink>   
      <h:outputText value="&nbsp;" rendered="#{questionScores.typeId != '6'}" escape="false"/>  
     
  </h:panelGroup>
  
  <h:panelGroup>
	<sakai:pager id="pager2" totalItems="#{questionScores.dataRows}" firstItem="#{questionScores.firstRow}" pageSize="#{questionScores.maxDisplayedRows}" textStatus="#{evaluationMessages.paging_status}" >
	  <f:valueChangeListener type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScorePagerListener" />
	</sakai:pager>
  </h:panelGroup>
</h:panelGrid>

</div>

  <!-- STUDENT RESPONSES AND GRADING -->
  <!-- note that we will have to hook up with the back end to get N at a time -->
<div class="table">
  <h:dataTable id="questionScoreTable" value="#{questionScores.agents}" var="description" styleClass="table table-bordered table-striped" columnClasses="textTable">

    <!-- NAME/SUBMISSION ID -->
    <h:column rendered="#{questionScores.anonymous eq 'false' && questionScores.sortType ne 'lastName'}">
     <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortLastName}" id="lastName" action="questionScores">
          <h:outputText value="#{evaluationMessages.name}" />
        <f:actionListener
         type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
        <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        <f:param name="sortBy" value="lastName" />
        <f:param name="sortAscending" value="true" />
        </h:commandLink>
     </f:facet>
      <sakai-user-photo user-id='<h:outputText value="#{description.idString}"/>' profile-popup="on"></sakai-user-photo>
     <h:panelGroup>
       <h:outputText value="<a name=\"" escape="false" />
       <h:outputText value="#{description.lastInitial}" />
       <h:outputText value="\"></a>" escape="false" />
       <h:commandLink title="#{evaluationMessages.t_student}" action="studentScores" immediate="true">
         <h:outputText value="#{description.lastName}" />
         <h:outputText value=", " rendered="#{description.lastInitial ne 'Anonymous'}"/>
         <h:outputText value="#{description.firstName}" />
         <h:outputText value="#{evaluationMessages.na}" rendered="#{description.lastInitial eq 'Anonymous'}" />
         <f:actionListener
            type="org.sakaiproject.tool.assessment.ui.listener.evaluation.StudentScoreListener" />
         <f:param name="studentid" value="#{description.idString}" />
         <f:param name="publishedIdd" value="#{questionScores.publishedId}" />
         <f:param name="gradingData" value="#{description.assessmentGradingId}" />
       </h:commandLink>
	   <f:verbatim><br/></f:verbatim>
	   <span class="itemAction">
	   <h:panelGroup rendered="#{description.email != null && description.email != '' && email.fromEmailAddress != null && email.fromEmailAddress != ''}">
		 <h:outputText value="<a href=\"mailto:" escape="false" />
	     <h:outputText value="#{description.email}" />
	     <h:outputText value="?subject=" escape="false" />
		 <h:outputText value="#{totalScores.assessmentName} #{commonMessages.feedback}\">" escape="false" />
         <h:outputText value="  #{evaluationMessages.email}" escape="false"/>
         <h:outputText value="</a>" escape="false" />
	   </h:panelGroup>
	   </span>
     </h:panelGroup>
    </h:column>

    <h:column rendered="#{questionScores.anonymous eq 'false' && questionScores.sortType eq 'lastName' && questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortLastName}" action="questionScores">
          <h:outputText value="#{evaluationMessages.name}" />
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortLastNameDescending}" rendered="#{questionScores.sortAscending}" url="/images/sortascending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
      </f:facet>
      <sakai-user-photo user-id='<h:outputText value="#{description.idString}"/>' profile-popup="on"></sakai-user-photo>
     <h:panelGroup>
       <h:outputText value="<a name=\"" escape="false" />
       <h:outputText value="#{description.lastInitial}" />
       <h:outputText value="\"></a>" escape="false" />
       <h:commandLink title="#{evaluationMessages.t_student}" action="studentScores" immediate="true">
         <h:outputText value="#{description.lastName}" />
         <h:outputText value=", " rendered="#{description.lastInitial ne 'Anonymous'}"/>
         <h:outputText value="#{description.firstName}" />
         <h:outputText value="#{evaluationMessages.na}" rendered="#{description.lastInitial eq 'Anonymous'}" />
         <f:actionListener
            type="org.sakaiproject.tool.assessment.ui.listener.evaluation.StudentScoreListener" />
         <f:param name="studentid" value="#{description.idString}" />
         <f:param name="publishedIdd" value="#{questionScores.publishedId}" />
         <f:param name="gradingData" value="#{description.assessmentGradingId}" />
       </h:commandLink>
       <f:verbatim><br/></f:verbatim>
	   <span class="itemAction">
	   <h:panelGroup rendered="#{description.email != null && description.email != '' && email.fromEmailAddress != null && email.fromEmailAddress != ''}">
		 <h:outputText value="<a href=\"mailto:" escape="false" />
	     <h:outputText value="#{description.email}" />
	     <h:outputText value="?subject=" escape="false" />
		 <h:outputText value="#{totalScores.assessmentName} #{commonMessages.feedback}\">" escape="false" />
         <h:outputText value="  #{evaluationMessages.email}" escape="false"/>
         <h:outputText value="</a>" escape="false" />
	   </h:panelGroup>
	   </span>
     </h:panelGroup>
	 </h:column>    
    
    <h:column rendered="#{questionScores.anonymous eq 'false' && questionScores.sortType eq 'lastName' && !questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortLastName}" action="questionScores">
          <h:outputText value="#{evaluationMessages.name}" />
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortLastNameAscending}" rendered="#{!questionScores.sortAscending}" url="/images/sortdescending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
      </f:facet>
      <sakai-user-photo user-id='<h:outputText value="#{description.idString}"/>' profile-popup="on"></sakai-user-photo>
     <h:panelGroup>
       <h:outputText value="<a name=\"" escape="false" />
       <h:outputText value="#{description.lastInitial}" />
       <h:outputText value="\"></a>" escape="false" />
       <h:commandLink title="#{evaluationMessages.t_student}" action="studentScores" immediate="true">
         <h:outputText value="#{description.lastName}" />
         <h:outputText value=", " rendered="#{description.lastInitial ne 'Anonymous'}"/>
         <h:outputText value="#{description.firstName}" />
         <h:outputText value="#{evaluationMessages.na}" rendered="#{description.lastInitial eq 'Anonymous'}" />
         <f:actionListener
            type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
         <f:actionListener
            type="org.sakaiproject.tool.assessment.ui.listener.evaluation.StudentScoreListener" />
         <f:param name="studentid" value="#{description.idString}" />
         <f:param name="publishedIdd" value="#{questionScores.publishedId}" />
         <f:param name="gradingData" value="#{description.assessmentGradingId}" />
       </h:commandLink>
       <f:verbatim><br/></f:verbatim>
	   <span class="itemAction">
	   <h:panelGroup rendered="#{description.email != null && description.email != '' && email.fromEmailAddress != null && email.fromEmailAddress != ''}">
		 <h:outputText value="<a href=\"mailto:" escape="false" />
	     <h:outputText value="#{description.email}" />
	     <h:outputText value="?subject=" escape="false" />
		 <h:outputText value="#{totalScores.assessmentName} #{commonMessages.feedback}\">" escape="false" />
         <h:outputText value="  #{evaluationMessages.email}" escape="false"/>
         <h:outputText value="</a>" escape="false" />
	   </h:panelGroup>
	   </span>
     </h:panelGroup>
	</h:column>  

	<!-- SUBMISSION ID -->
    <h:column rendered="#{questionScores.anonymous eq 'true' && questionScores.sortType ne 'assessmentGradingId'}">
     <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortSubmissionId}" action="questionScores">
          <h:outputText value="#{evaluationMessages.sub_id}" />
      <f:actionListener
         type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
        <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        <f:param name="sortBy" value="assessmentGradingId" />
        </h:commandLink>
     </f:facet>
     <h:panelGroup>
       <h:commandLink title="#{evaluationMessages.t_student}" action="studentScores" immediate="true">
         <h:outputText value="#{description.assessmentGradingId}" />
         <f:actionListener
            type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
         <f:actionListener
            type="org.sakaiproject.tool.assessment.ui.listener.evaluation.StudentScoreListener" />
         <f:param name="studentid" value="#{description.idString}" />
         <f:param name="studentName" value="#{description.assessmentGradingId}" />
         <f:param name="publishedIdd" value="#{questionScores.publishedId}" />
         <f:param name="gradingData" value="#{description.assessmentGradingId}" />
       </h:commandLink>
     </h:panelGroup>
    </h:column>

    <h:column rendered="#{questionScores.anonymous eq 'true' && questionScores.sortType eq 'assessmentGradingId' && questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortSubmissionId}" action="questionScores">
          <h:outputText value="#{evaluationMessages.sub_id}" />
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortSubmissionIdDescending}" rendered="#{questionScores.sortAscending}" url="/images/sortascending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
      </f:facet>
     <h:panelGroup>
       <h:commandLink title="#{evaluationMessages.t_student}" action="studentScores" immediate="true">
         <h:outputText value="#{description.assessmentGradingId}" />
         <f:actionListener
            type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
         <f:actionListener
            type="org.sakaiproject.tool.assessment.ui.listener.evaluation.StudentScoreListener" />
         <f:param name="studentid" value="#{description.idString}" />
         <f:param name="studentName" value="#{description.assessmentGradingId}" />
         <f:param name="publishedIdd" value="#{questionScores.publishedId}" />
         <f:param name="gradingData" value="#{description.assessmentGradingId}" />
       </h:commandLink>
     </h:panelGroup>
    </h:column>    
    
    <h:column rendered="#{questionScores.anonymous eq 'true' && questionScores.sortType eq 'assessmentGradingId' && !questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortSubmissionId}" action="questionScores">
          <h:outputText value="#{evaluationMessages.sub_id}" />
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortSubmissionIdAscending}" rendered="#{!questionScores.sortAscending}" url="/images/sortdescending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
      </f:facet>
      <h:panelGroup>
       <h:commandLink title="#{evaluationMessages.t_student}" action="studentScores" immediate="true">
         <h:outputText value="#{description.assessmentGradingId}" />
         <f:actionListener
            type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
         <f:actionListener
            type="org.sakaiproject.tool.assessment.ui.listener.evaluation.StudentScoreListener" />
         <f:param name="studentid" value="#{description.idString}" />
         <f:param name="studentName" value="#{description.assessmentGradingId}" />
         <f:param name="publishedIdd" value="#{questionScores.publishedId}" />
         <f:param name="gradingData" value="#{description.assessmentGradingId}" />
       </h:commandLink>
     </h:panelGroup>
    </h:column>  


   <!-- STUDENT ID -->
    <h:column rendered="#{questionScores.anonymous eq 'false' && questionScores.sortType!='agentDisplayId'}" >
     <f:facet name="header">
       <h:commandLink title="#{evaluationMessages.t_sortUserId}" id="agentDisplayId" action="questionScores" >
          <h:outputText value="#{evaluationMessages.uid}" />
      <f:actionListener
         type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
        <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        <f:param name="sortBy" value="agentDisplayId" />
        <f:param name="sortAscending" value="true" />
        </h:commandLink>
     </f:facet>
        <h:outputText value="#{description.agentDisplayId}" />
    </h:column>

    <h:column rendered="#{questionScores.anonymous eq 'false' && questionScores.sortType eq 'agentDisplayId' && questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortUserId}" action="questionScores">
          <h:outputText value="#{evaluationMessages.uid}" />
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortUserIdDescending}" rendered="#{questionScores.sortAscending}" url="/images/sortascending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
      </f:facet>
        <h:outputText value="#{description.agentDisplayId}" />
    </h:column>    
    
    <h:column rendered="#{questionScores.anonymous eq 'false' && questionScores.sortType eq 'agentDisplayId' && !questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortUserId}" action="questionScores">
          <h:outputText value="#{evaluationMessages.uid}" />
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortUserIdAscending}" rendered="#{!questionScores.sortAscending}" url="/images/sortdescending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
      </f:facet>
        <h:outputText value="#{description.agentDisplayId}" />
    </h:column>      


    <!-- ROLE -->
    <h:column rendered="#{questionScores.sortType ne 'role'}">
     <f:facet name="header" >
        <h:commandLink title="#{evaluationMessages.t_sortRole}" id="role" action="questionScores">
          <h:outputText value="#{evaluationMessages.role}" />
      <f:actionListener
         type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
        <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        <f:param name="sortBy" value="role" />
        <f:param name="sortAscending" value="true"/>
        </h:commandLink>
     </f:facet>
        <h:outputText value="#{description.role}"/>
    </h:column>

    <h:column rendered="#{questionScores.sortType eq 'role' && questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortRole}" action="questionScores">
          <h:outputText value="#{evaluationMessages.role}" />
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortRoleDescending}" rendered="#{questionScores.sortAscending}" url="/images/sortascending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
      </f:facet>
        <h:outputText value="#{description.role}"/>
    </h:column>    
    
    <h:column rendered="#{questionScores.sortType eq 'role' && !questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortRole}" action="questionScores">
          <h:outputText value="#{evaluationMessages.role}" />
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortRoleAscending}" rendered="#{!questionScores.sortAscending}" url="/images/sortdescending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
      </f:facet>
        <h:outputText value="#{description.role}"/>
    </h:column>      


    <!-- DATE -->
    <h:column rendered="#{questionScores.sortType!='submittedDate'}">
     <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortSubmittedDate}" id="submittedDate" action="questionScores">
          <h:outputText value="#{evaluationMessages.date}" />
      <f:actionListener
         type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
        <f:actionListener
          type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        <f:param name="sortBy" value="submittedDate" />
        <f:param name="sortAscending" value="true"/>
        </h:commandLink>
     </f:facet>
        <h:outputText value="#{description.submittedDate}">
          <f:convertDateTime dateStyle="medium" timeStyle="short" timeZone="#{author.userTimeZone}" />
        </h:outputText>
    </h:column>

    <h:column rendered="#{questionScores.sortType eq 'submittedDate' && questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortSubmittedDate}" action="questionScores">
          <h:outputText value="#{evaluationMessages.date}" />
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortSubmittedDateDescending}" rendered="#{questionScores.sortAscending}" url="/images/sortascending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
      </f:facet>
        <h:outputText value="#{description.submittedDate}">
          <f:convertDateTime dateStyle="medium" timeStyle="short" timeZone="#{author.userTimeZone}" />
        </h:outputText>
    </h:column>    
    
    <h:column rendered="#{questionScores.sortType eq 'submittedDate' && !questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortSubmittedDate}" action="questionScores">
          <h:outputText value="#{evaluationMessages.date}" />
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortSubmittedDateAscending}" rendered="#{!questionScores.sortAscending}" url="/images/sortdescending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
      </f:facet>
        <h:outputText value="#{description.submittedDate}">
          <f:convertDateTime dateStyle="medium" timeStyle="short" timeZone="#{author.userTimeZone}" />
        </h:outputText>
    </h:column>    

    <!-- TIME ELAPSED -->
    <h:column rendered="#{questionScores.trackingQuestions && questionScores.sortType!='timeElapsed'}">
     <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortTimeElapsed}" id="timeElapsed" action="questionScores">
          <h:outputText value="#{evaluationMessages.time_elapsed}" />
      <f:actionListener
         type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
        <f:actionListener
          type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        <f:param name="sortBy" value="timeElapsed" />
        <f:param name="sortAscending" value="true"/>
        </h:commandLink>
     </f:facet>
        <h:outputText value="#{description.formattedTimeElapsed}" />
    </h:column>

    <h:column rendered="#{questionScores.trackingQuestions && questionScores.sortType eq 'timeElapsed' && questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortTimeElapsed}" action="questionScores">
          <h:outputText value="#{evaluationMessages.time_elapsed}" />
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortTimeElapsedDescending}" rendered="#{questionScores.sortAscending}" url="/images/sortascending.gif"/>
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>
      </f:facet>
        <h:outputText value="#{description.formattedTimeElapsed}" />
    </h:column>
    
    <h:column rendered="#{questionScores.trackingQuestions && questionScores.sortType eq 'timeElapsed' && !questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortTimeElapsed}" action="questionScores">
          <h:outputText value="#{evaluationMessages.time_elapsed}" />
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortTimeElapsedAscending}" rendered="#{!questionScores.sortAscending}" url="/images/sortdescending.gif"/>
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>
      </f:facet>
        <h:outputText value="#{description.formattedTimeElapsed}" />
    </h:column>

    <!-- SCORE -->
    <h:column rendered="#{questionScores.sortType!='totalAutoScore'}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortScore}" id="score" action="questionScores">
          <h:outputText value="#{evaluationMessages.score}" />
      <f:actionListener
         type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
             type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        <f:param name="sortBy" value="totalAutoScore" />
        <f:param name="sortAscending" value="true" />
        </h:commandLink>
      </f:facet>
      <h:inputText value="#{description.roundedTotalAutoScore}"
                    size="5"
                    id="qscore"
                    styleClass="adjustedScore#{description.assessmentGradingId}.#{questionScores.itemId}"
                    required="false"
                    disabled="#{questionScores.deliveryItemCancelled}"
                    onchange="toPoint(this.id);">
      </h:inputText>
      <h:message for="qscore" styleClass="text-danger"/>
       <h:outputLink title="#{evaluationMessages.saverubricgrading}"
                        rendered="#{questionScores.hasAssociatedRubric}"
                        value="#"
                        onclick="initRubricDialogWrapper(#{description.assessmentGradingId}+'.'+#{questionScores.itemId}); return false;"
                        onkeypress="initRubricDialogWrapper(#{description.assessmentGradingId}+'.'+#{questionScores.itemId}); return false;" >
        <h:outputText styleClass="si si-sakai-rubrics" id="rubrics-question-icon1" title="#{authorMessages.question_use_rubric}" style="margin-left:0.5em"/>
      </h:outputLink>
      <%@ include file="/jsf/evaluation/rubricModal.jsp" %> 
 </h:column>
 
 
    <h:column rendered="#{questionScores.sortType eq 'totalAutoScore' && questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortScore}" action="questionScores">
          <h:outputText value="#{evaluationMessages.score}" />
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortAdjustScoreDescending}" rendered="#{questionScores.sortAscending}" url="/images/sortascending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
      </f:facet>
	  <h:inputText value="#{description.roundedTotalAutoScore}"
                    size="5"
                    id="qscore2"
                    styleClass="adjustedScore#{description.assessmentGradingId}.#{questionScores.itemId}"
                    required="false"
                    onchange="toPoint(this.id);">
	  </h:inputText>
	  <h:message for="qscore2" style="color:red"/>
      <h:panelGroup styleClass="d-none d-sm-inline" rendered="#{questionScores.itemData.minScore > 0 || questionScores.itemData.discount > 0}">
        <h:outputText value=" (" />
        <h:outputText value="#{authorMessages.answer_min_point_short}: #{questionScores.itemData.minScore}" rendered="#{questionScores.itemData.minScore > 0}" />
        <h:outputText value=", " rendered="#{questionScores.itemData.minScore > 0 && questionScores.itemData.discount > 0}" />
        <h:outputText value="#{authorMessages.answer_discount_point_short}: #{questionScores.itemData.discount}" rendered="#{questionScores.itemData.discount > 0}" />
        <h:outputText value=")" />
      </h:panelGroup>
	  <h:outputLink title="#{evaluationMessages.saverubricgrading}"
                    rendered="#{questionScores.hasAssociatedRubric}"
                    value="#"
                    onclick="initRubricDialogWrapper(#{description.assessmentGradingId}+'.'+#{questionScores.itemId}); return false;"
                    onkeypress="initRubricDialogWrapper(#{description.assessmentGradingId}+'.'+#{questionScores.itemId}); return false;" >
	  	<h:outputText styleClass="si si-sakai-rubrics" id="rubrics-question-icon2" title="#{authorMessages.question_use_rubric}" style="margin-left:0.5em"/>
	  </h:outputLink>
	  <%@ include file="/jsf/evaluation/rubricModal.jsp" %>
    </h:column>    
    
    <h:column rendered="#{questionScores.sortType eq 'totalAutoScore' && !questionScores.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{evaluationMessages.t_sortScore}" action="questionScores">
          <h:outputText value="#{evaluationMessages.score}" />
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortAdjustScoreAscending}" rendered="#{!questionScores.sortAscending}" url="/images/sortdescending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
      </f:facet>
	  <h:inputText value="#{description.roundedTotalAutoScore}"
                    size="5"
                    id="qscore3"
                    styleClass="adjustedScore#{description.assessmentGradingId}.#{questionScores.itemId}"
                    required="false"
                    onchange="toPoint(this.id);">
	  </h:inputText>
	  <h:message for="qscore2" styleClass="text-danger"/>
      <h:panelGroup styleClass="d-none d-sm-inline" rendered="#{questionScores.itemData.minScore > 0 || questionScores.itemData.discount > 0}">
        <h:outputText value=" (" />
        <h:outputText value="#{authorMessages.answer_min_point_short}: #{questionScores.itemData.minScore}" rendered="#{questionScores.itemData.minScore > 0}" />
        <h:outputText value=", " rendered="#{questionScores.itemData.minScore > 0 && questionScores.itemData.discount > 0}" />
        <h:outputText value="#{authorMessages.answer_discount_point_short}: #{questionScores.itemData.discount}" rendered="#{questionScores.itemData.discount > 0}" />
        <h:outputText value=")" />
      </h:panelGroup>
	  <h:outputLink title="#{evaluationMessages.saverubricgrading}"
                    rendered="#{questionScores.hasAssociatedRubric}"
                    value="#"
                    onclick="initRubricDialogWrapper(#{description.assessmentGradingId}+'.'+#{questionScores.itemId}); return false;"
                    onkeypress="initRubricDialogWrapper(#{description.assessmentGradingId}+'.'+#{questionScores.itemId}); return false;" >
	  	<h:outputText styleClass="si si-sakai-rubrics" id="rubrics-question-icon3" title="#{authorMessages.question_use_rubric}" style="margin-left:0.5em"/>
	  </h:outputLink>
       <%@ include file="/jsf/evaluation/rubricModal.jsp" %>
    </h:column>

    <!-- ANSWER -->
    <h:column rendered="#{questionScores.sortType!='answer'}">
      <f:facet name="header">
        <h:panelGroup>
		  <h:outputText value="#{commonMessages.student_response}" 
             rendered="#{questionScores.typeId == '6' || questionScores.typeId == '7'}"/>
          <h:commandLink title="#{evaluationMessages.t_sortResponse}" id="answer" action="questionScores" >
            <h:outputText value="#{commonMessages.student_response}" 
               rendered="#{questionScores.typeId != '6' && questionScores.typeId != '7'}"/>
            <f:actionListener
               type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
            <f:actionListener
               type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
            <f:param name="sortBy" value="answer" />
            <f:param name="sortAscending" value="true" />
          </h:commandLink>
        </h:panelGroup>
      </f:facet>
      <!-- display of answer to file upload question is diffenent from other types - daisyf -->
      <h:outputText value="#{description.answer}" escape="false" rendered="#{questionScores.typeId != '1' and questionScores.typeId != '2' and questionScores.typeId != '9' and questionScores.typeId != '12' and questionScores.typeId != '6' && questionScores.typeId != '7' && questionScores.typeId != '5' && questionScores.typeId != '16'}" >
      	<f:converter converterId="org.sakaiproject.tool.assessment.jsf.convert.AnswerSurveyConverter" />
      </h:outputText>

      <%-- Multiple choice, Multiple correct, Multiple single selection and matching questions --%>
      <h:outputText value="#{description.answer}" escape="false" rendered="#{questionScores.typeId == '1' || questionScores.typeId == '2' || questionScores.typeId == '9' || questionScores.typeId == '12'}">
          <f:converter converterId="org.sakaiproject.tool.assessment.jsf.convert.AnswerHTMLConverter" />
      </h:outputText>

    <h:panelGroup rendered="#{questionScores.selectedSARationaleView == '1' && questionScores.typeId == '5'}">
    <h:outputText value="#{description.answer}" escape="false"/>
		<h:outputLink title="#{evaluationMessages.t_fullShortAnswer}"   value="#" onclick="window.open('/portal/tool/#{requestScope['sakai.tool.placement.id']}/jsf/evaluation/fullShortAnswer.faces?idString=#{description.assessmentGradingId}','fullShortAnswer','width=600,height=600,scrollbars=yes, resizable=yes');" onkeypress="window.open('/portal/tool/#{requestScope['sakai.tool.placement.id']}/jsf/evaluation/fullShortAnswer.faces?idString=#{description.assessmentGradingId}','fullShortAnswer','width=600,height=600,scrollbars=yes, resizable=yes');">
    		<h:outputText  value="(#{evaluationMessages.click_shortAnswer})" rendered="#{description.answer != 'No Answer'}"/>
    	</h:outputLink>
    </h:panelGroup>
    
    <h:panelGroup rendered="#{questionScores.selectedSARationaleView == '2' && questionScores.typeId == '5'}">
		<h:outputText  escape="false" value="#{description.fullAnswer}"/>
    </h:panelGroup>
    
    <h:panelGroup rendered="#{(questionScores.typeId == '1' || questionScores.typeId == '2' || questionScores.typeId == '12' || questionScores.typeId == '4') && description.rationale ne '' && questionScores.selectedSARationaleView == '1'}">
		<h:outputLink title="#{evaluationMessages.t_rationale}"  value="#" onclick="javascript:window.open('rationale.faces?idString=#{description.assessmentGradingId}','rationale','width=600,height=600,scrollbars=yes, resizable=yes');" onkeypress="javascript:window.open('rationale.faces?idString=#{description.assessmentGradingId}','rationale','width=600,height=600,scrollbars=yes, resizable=yes');">
    		<h:outputText  value="(#{evaluationMessages.click_rationale})" />
    	</h:outputLink>
    </h:panelGroup>
    
    <h:panelGroup rendered="#{(questionScores.typeId == '1' || questionScores.typeId == '2' || questionScores.typeId == '12' || questionScores.typeId == '4') && description.rationale ne '' && questionScores.selectedSARationaleView == '2'}">
		<br /><br />
		<h:outputText escape="false" value="#{description.rationale}"/>
    </h:panelGroup>

      <h:panelGroup rendered="#{questionScores.typeId == '6'}">
        <f:subview id="displayFileUpload2">
          <%@ include file="/jsf/evaluation/item/displayFileUploadAnswer.jsp" %>
        </f:subview>
      </h:panelGroup>

      <h:panelGroup rendered="#{questionScores.typeId == '7'}">
        <f:subview id="displayAudioRecording2">
          <%@ include file="/jsf/evaluation/item/displayAudioRecordingAnswer.jsp" %>
        </f:subview>
      </h:panelGroup>
      
      <h:panelGroup rendered="#{questionScores.typeId == '16'}" >
 		<h:outputLink title="#{evaluationMessages.t_hotspotanswer}"      
 			value="#imageMapContainer" 
 			onclick="javascript:loadAnswer('#{description.answer}');" 
 			onkeypress="javascript:loadAnswer('#{description.answer}');">
 			
 			<h:outputText  value="#{evaluationMessages.show_hotspotanswer}"/>
 		</h:outputLink>
      </h:panelGroup>
      
    </h:column>

    <h:column rendered="#{questionScores.sortType eq 'answer' && questionScores.sortAscending}">
      <f:facet name="header">
      <h:panelGroup>
		  <h:outputText value="#{commonMessages.student_response}" 
             rendered="#{questionScores.typeId == '6' || questionScores.typeId == '7'}"/>
          <h:commandLink title="#{evaluationMessages.t_sortResponse}" action="questionScores" >
            <h:outputText value="#{commonMessages.student_response}" 
               rendered="#{questionScores.typeId != '6' && questionScores.typeId != '7'}"/>
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortResponseDescending}" rendered="#{questionScores.sortAscending && questionScores.typeId != '6' && questionScores.typeId != '7'}" url="/images/sortascending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>  
          </h:panelGroup>  
      </f:facet>
      <h:outputText value="#{description.answer}" escape="false" rendered="#{questionScores.typeId != '1' and questionScores.typeId != '2' and questionScores.typeId != '9' and questionScores.typeId != '12' and questionScores.typeId != '6' and questionScores.typeId != '7' && questionScores.typeId != '5' and questionScores.typeId != '16'}" >
      	<f:converter converterId="org.sakaiproject.tool.assessment.jsf.convert.AnswerSurveyConverter" />
      </h:outputText>

      <%-- Multiple choice, Multiple correct, Multiple single selection and matching questions --%>
      <h:outputText value="#{description.answer}" escape="false" rendered="#{questionScores.typeId == '1' || questionScores.typeId == '2' || questionScores.typeId == '9' || questionScores.typeId == '12'}">
          <f:converter converterId="org.sakaiproject.tool.assessment.jsf.convert.AnswerHTMLConverter" />
      </h:outputText>

    <h:panelGroup rendered="#{questionScores.selectedSARationaleView == '1' && questionScores.typeId == '5'}">
    <h:outputText value="#{description.answer}" escape="false"/>
		<h:outputLink title="#{evaluationMessages.t_fullShortAnswer}"   value="#" onclick="javascript:window.open('fullShortAnswer.faces?idString=#{description.assessmentGradingId}','fullShortAnswer','width=600,height=600,scrollbars=yes, resizable=yes');" onkeypress="javascript:window.open('fullShortAnswer.faces?idString=#{description.assessmentGradingId}','fullShortAnswer','width=600,height=600,scrollbars=yes, resizable=yes');">
    		<h:outputText  value="(#{evaluationMessages.click_shortAnswer})" rendered="#{description.answer != 'No Answer'}"/>
    	</h:outputLink>
    </h:panelGroup>

    
    <h:panelGroup rendered="#{questionScores.selectedSARationaleView == '2' && questionScores.typeId == '5'}">
		<h:outputText  escape="false" value="#{description.fullAnswer}"/>
    </h:panelGroup>
    
    <h:panelGroup rendered="#{(questionScores.typeId == '1' || questionScores.typeId == '2' || questionScores.typeId == '12' || questionScores.typeId == '4') && description.rationale ne '' && questionScores.selectedSARationaleView == '1'}">
		<h:outputLink title="#{evaluationMessages.t_rationale}"  
	value="#" onclick="javascript:window.open('rationale.faces?idString=#{description.assessmentGradingId}','rationale','width=600,height=600,scrollbars=yes, resizable=yes');" onkeypress="javascript:window.open('rationale.faces?idString=#{description.assessmentGradingId}','rationale','width=600,height=600,scrollbars=yes, resizable=yes');">
    		<h:outputText  value="(#{evaluationMessages.click_rationale})" />
    	</h:outputLink>
    </h:panelGroup>
    
    <h:panelGroup rendered="#{(questionScores.typeId == '1' || questionScores.typeId == '2' || questionScores.typeId == '12' || questionScores.typeId == '4') && description.rationale ne '' && questionScores.selectedSARationaleView == '2'}">
		<h:outputText escape="false" value="#{description.rationale}"/>
    </h:panelGroup>

    <h:panelGroup rendered="#{questionScores.typeId == '6'}">
        <f:subview id="displayFileUpload3">
          <%@ include file="/jsf/evaluation/item/displayFileUploadAnswer.jsp" %>
        </f:subview>
      </h:panelGroup>

      <h:panelGroup rendered="#{questionScores.typeId == '7'}">
        <f:subview id="displayAudioRecording3">
          <%@ include file="/jsf/evaluation/item/displayAudioRecordingAnswer.jsp" %>
        </f:subview>
      </h:panelGroup>
       <h:panelGroup rendered="#{questionScores.typeId == '16'}" >
		<h:outputLink title="#{evaluationMessages.t_hotspotanswer}"      
			value="#imageMapContainer" 
			onclick="javascript:loadAnswer('#{description.answer}');" 
			onkeypress="javascript:loadAnswer('#{description.answer}');">
			
			<h:outputText  value="#{evaluationMessages.show_hotspotanswer}"/>
		</h:outputLink>
      </h:panelGroup>
    </h:column>    
    
    <h:column rendered="#{questionScores.sortType eq 'answer' && !questionScores.sortAscending}">
      <f:facet name="header">
		  <h:panelGroup>
		  <h:outputText value="#{commonMessages.student_response}" 
             rendered="#{questionScores.typeId == '6' || questionScores.typeId == '7'}"/>
          <h:commandLink title="#{evaluationMessages.t_sortResponse}" action="questionScores" >
            <h:outputText value="#{commonMessages.student_response}" 
               rendered="#{questionScores.typeId != '6' && questionScores.typeId != '7'}"/>
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortResponseAscending}" rendered="#{!questionScores.sortAscending && questionScores.typeId != '6' && questionScores.typeId != '7'}" url="/images/sortdescending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>    
          </h:panelGroup>
      </f:facet>
    <h:outputText value="#{description.answer}" escape="false" rendered="#{questionScores.typeId != '1' and questionScores.typeId != '2' and questionScores.typeId != '9' and questionScores.typeId != '12' and questionScores.typeId != '6' and questionScores.typeId != '7' && questionScores.typeId != '5' and questionScores.typeId != '16'}" />

    <%-- Multiple choice, Multiple correct, Multiple single selection and matching questions --%>
    <h:outputText value="#{description.answer}" escape="false" rendered="#{ questionScores.typeId == '1' || questionScores.typeId == '2' || questionScores.typeId == '9' || questionScores.typeId == '12'}">
        <f:converter converterId="org.sakaiproject.tool.assessment.jsf.convert.AnswerHTMLConverter" />
    </h:outputText>

    <h:panelGroup rendered="#{questionScores.selectedSARationaleView == '1' && questionScores.typeId == '5'}">
    <h:outputText value="#{description.answer}" escape="false"/>
		<h:outputLink title="#{evaluationMessages.t_fullShortAnswer}"   value="#" onclick="javascript:window.open('fullShortAnswer.faces?idString=#{description.assessmentGradingId}','fullShortAnswer','width=600,height=600,scrollbars=yes, resizable=yes');" onkeypress="javascript:window.open('fullShortAnswer.faces?idString=#{description.assessmentGradingId}','fullShortAnswer','width=600,height=600,scrollbars=yes, resizable=yes');">
    		<h:outputText  value="(#{evaluationMessages.click_shortAnswer})" rendered="#{description.answer != 'No Answer'}" />
    	</h:outputLink>
    </h:panelGroup>
    
    <h:panelGroup rendered="#{questionScores.selectedSARationaleView == '2' && questionScores.typeId == '5'}">
		<h:outputText  escape="false" value="#{description.fullAnswer}"/>
    </h:panelGroup>
    
    <h:panelGroup rendered="#{(questionScores.typeId == '1' || questionScores.typeId == '2' || questionScores.typeId == '12' || questionScores.typeId == '4') && description.rationale ne '' && questionScores.selectedSARationaleView == '1'}">
		<h:outputLink title="#{evaluationMessages.t_rationale}"  
	value="#" onclick="javascript:window.open('rationale.faces?idString=#{description.assessmentGradingId}','rationale','width=600,height=600,scrollbars=yes, resizable=yes');" onkeypress="javascript:window.open('rationale.faces?idString=#{description.assessmentGradingId}','rationale','width=600,height=600,scrollbars=yes, resizable=yes');">
    		<h:outputText  value="(#{evaluationMessages.click_rationale})" />
    	</h:outputLink>
    </h:panelGroup>
    
    <h:panelGroup rendered="#{(questionScores.typeId == '1' || questionScores.typeId == '2' || questionScores.typeId == '12' || questionScores.typeId == '4') && description.rationale ne '' && questionScores.selectedSARationaleView == '2'}">
		<h:outputText escape="false" value="#{description.rationale}"/>
    </h:panelGroup>

          <h:panelGroup rendered="#{questionScores.typeId == '6'}">
        <f:subview id="displayFileUpload4">
          <%@ include file="/jsf/evaluation/item/displayFileUploadAnswer.jsp" %>
        </f:subview>
      </h:panelGroup>

      <h:panelGroup rendered="#{questionScores.typeId == '7'}">
        <f:subview id="displayAudioRecording4">
          <%@ include file="/jsf/evaluation/item/displayAudioRecordingAnswer.jsp" %>
        </f:subview>
      </h:panelGroup>
      <h:panelGroup rendered="#{questionScores.typeId == '16'}" >
		<h:outputLink title="#{evaluationMessages.t_hotspotanswer}"      
			value="#imageMapContainer" 
			onclick="javascript:loadAnswer('#{description.answer}');" 
			onkeypress="javascript:loadAnswer('#{description.answer}');">
			
			<h:outputText  value="#{evaluationMessages.show_hotspotanswer}"/>
		</h:outputLink>
      </h:panelGroup>
    </h:column>
     
	<!-- ANSWER KEY -->
	<h:column rendered="#{questionScores.typeId == '15' && questionScores.sortType!='answerKey'}">
     <f:facet name="header">
     
        <h:panelGroup>
          <h:commandLink title="#{evaluationMessages.t_sortAnswerKey}" id="answerKey" action="questionScores" >
            <h:outputText value="#{commonMessages.answer_key}"/>
            <f:actionListener
               type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
            <f:actionListener
               type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
            <f:param name="sortBy" value="answerKey" />
            <f:param name="sortAscending" value="true" />
          </h:commandLink>
        </h:panelGroup>        
     </f:facet>	
     
	 <h:outputText value="#{description.answerKey}" escape="false"/>
	</h:column>
	
	<!--  Answer Key sortDescending -->
	<h:column rendered="#{questionScores.typeId == '15' && questionScores.sortType eq 'answerKey' && questionScores.sortAscending}">
     <f:facet name="header">
     
        <h:panelGroup>
          <h:commandLink title="#{evaluationMessages.t_sortAnswerKey}" action="questionScores" >
            <h:outputText value="#{commonMessages.answer_key}"/>
            <f:param name="sortAscending" value="false" />
            <h:graphicImage alt="#{evaluationMessages.alt_sortAnswerKeyDescending}" rendered="#{questionScores.sortAscending}" url="/images/sortascending.gif"/>
      	    <f:actionListener
              type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
            <f:actionListener
              type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>
        </h:panelGroup>        
     </f:facet>	
     
	 <h:outputText value="#{description.answerKey}" escape="false"/>
	</h:column>	
	
	<!--  Answer Key sortAscending -->
	<h:column rendered="#{questionScores.typeId == '15' && questionScores.sortType eq 'answerKey' && !questionScores.sortAscending}">
     <f:facet name="header">
     
        <h:panelGroup>
          <h:commandLink title="#{evaluationMessages.t_sortAnswerKey}" action="questionScores" >
            <h:outputText value="#{commonMessages.answer_key}"/>
            <f:param name="sortAscending" value="true" />
            <h:graphicImage alt="#{evaluationMessages.alt_sortAnswerKeyAscending}" rendered="#{!questionScores.sortAscending}" url="/images/sortdescending.gif"/>
      	    <f:actionListener
              type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
            <f:actionListener
              type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
          </h:commandLink>
        </h:panelGroup>        
     </f:facet>	
     
	 <h:outputText value="#{description.answerKey}" escape="false"/>
	</h:column>	

    <!-- COMMENT -->
    <h:column rendered="#{questionScores.sortType!='comments'}">
     <f:facet name="header">
      <h:panelGroup>
      <h:commandLink title="#{evaluationMessages.t_sortCommentsForStudent}" id="comments" action="questionScores">
      <f:actionListener
         type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
        <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        <h:outputText value="#{evaluationMessages.comment_for_student}"/>
        <f:param name="sortBy" value="comments" />
      </h:commandLink>
	  <h:outputText value="&nbsp;&nbsp;" escape="false"/>
	  
      <h:outputLink title="#{evaluationMessages.whats_this_link}" value="#" onclick="javascript:window.open('../evaluation/totalScoresCommentPopUp.faces','CommentForStudent','width=510,height=515,scrollbars=yes, resizable=yes');" onkeypress="javascript:window.open('../evaluation/totalScoresCommentPopUp.faces','CommentForStudent','width=510,height=515,scrollbars=yes, resizable=yes');" >
        <h:outputText  value="#{evaluationMessages.whats_this_link}"/>
      </h:outputLink>
	  </h:panelGroup>
     </f:facet>
     <h:inputTextarea value="#{description.comments}" rows="3" cols="30"/>
     <%@ include file="/jsf/evaluation/questionScoreAttachment.jsp" %>
    </h:column>

    <h:column rendered="#{questionScores.sortType eq 'comments' && questionScores.sortAscending}">
      <f:facet name="header">
        <h:panelGroup>
        <h:commandLink title="#{evaluationMessages.t_sortCommentsForStudent}" action="questionScores">
          <h:outputText value="#{evaluationMessages.comment_for_student}" />
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortCommentDescending}" rendered="#{questionScores.sortAscending}" url="/images/sortascending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        </h:commandLink>
		<h:outputText value="&nbsp;&nbsp;" escape="false"/>

		<h:outputLink title="#{evaluationMessages.whats_this_link}" value="#" onclick="javascript:window.open('../evaluation/totalScoresCommentPopUp.faces','CommentForStudent','width=510,height=515,scrollbars=yes, resizable=yes');" onkeypress="javascript:window.open('../evaluation/totalScoresCommentPopUp.faces','CommentForStudent','width=510,height=515,scrollbars=yes, resizable=yes');" >
			<h:outputText  value="#{evaluationMessages.whats_this_link}"/>
		</h:outputLink>
	  </h:panelGroup>
      </f:facet>

      <h:inputTextarea value="#{description.comments}" rows="3" cols="30"/>
      <%@ include file="/jsf/evaluation/questionScoreAttachment.jsp" %>
    </h:column>    
    
    <h:column rendered="#{questionScores.sortType eq 'comments' && !questionScores.sortAscending}">
      <f:facet name="header">
        <h:panelGroup>
        <h:commandLink title="#{evaluationMessages.t_sortCommentsForStudent}" action="questionScores">
          <h:outputText value="#{evaluationMessages.comment_for_student}" />
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{evaluationMessages.alt_sortCommentAscending}" rendered="#{!questionScores.sortAscending}" url="/images/sortdescending.gif"/>
      	  <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
          <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
        </h:commandLink>
		<h:outputText value="&nbsp;&nbsp;" escape="false"/>

		<h:outputLink title="#{evaluationMessages.whats_this_link}" value="#" onclick="javascript:window.open('../evaluation/totalScoresCommentPopUp.faces','CommentForStudent','width=510,height=515,scrollbars=yes, resizable=yes');" onkeypress="javascript:window.open('../evaluation/totalScoresCommentPopUp.faces','CommentForStudent','width=510,height=515,scrollbars=yes, resizable=yes');" >
			<h:outputText  value="#{evaluationMessages.whats_this_link}"/>
		</h:outputLink>
	  </h:panelGroup>
      </f:facet>
     <h:inputTextarea value="#{description.comments}" rows="3" cols="30"/>
     <%@ include file="/jsf/evaluation/questionScoreAttachment.jsp" %>
    </h:column> 

  </h:dataTable>
</div>

<p class="act">
   <%-- <h:commandButton value="#{evaluationMessages.save_exit}" action="author"/> --%>
   <h:commandButton id="save" styleClass="active" value="#{evaluationMessages.saver}" action="questionScores" type="submit" >
      <f:actionListener
         type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreUpdateListener" />
      <f:actionListener
         type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
   </h:commandButton>
   <h:commandButton id="downloadRubrics" styleClass="active" value="#{evaluationMessages.rubrics_button_download}" action="questionScores" type="submit" rendered="#{questionScores.hasAssociatedRubric}">
      <f:actionListener
         type="org.sakaiproject.tool.assessment.ui.listener.evaluation.ExportRubrics" />
   </h:commandButton>
   <h:commandButton id="cancel" value="#{commonMessages.cancel_action}" action="totalScores" immediate="true"/>
</p>

<%--Question Cancellation Modal--%>
<div id="cancelQuestionModal" class="modal modal-lg fade question-cancel-modal" tabindex="-1">
  <h:panelGroup styleClass="modal-dialog" layout="block">
    <h:panelGroup styleClass="modal-content" layout="block">
      <h:panelGroup styleClass="modal-header" layout="block">
        <h2 class="modal-title">
          <h:outputText value="#{commonMessages.cancel_question}" />
        </h2>
        <button type="button" class="btn btn-close me-1" data-bs-dismiss="modal"
            aria-label='<h:outputText value="#{authorMessages.button_close}" />'>
        </button>
      </h:panelGroup>
      <h:panelGroup styleClass="modal-body" layout="block">
        <h:panelGroup styleClass="sak-banner-info" layout="block">
          <h:outputText value="#{commonMessages.cancel_question_info_cancellation}" />
          <br /><br />
          <strong>
            <h:outputText value="#{commonMessages.cancel_question_reduce_total}:" />
          </strong>
          <h:outputText value="#{commonMessages.cancel_question_info_reduce_total}" />
          <br /><br />
          <strong>
            <h:outputText value="#{commonMessages.cancel_question_distribute_points}:" />
          </strong>
          <h:outputText value="#{commonMessages.cancel_question_info_distribute_points}" />
        </h:panelGroup>
        <h:panelGroup styleClass="sak-banner-warn" layout="block">
          <h:panelGroup rendered="#{questionScores.emiItemPresent}">
            <h:outputText value="#{commonMessages.cancel_question_info_emi} " />
            <br /><br />
          </h:panelGroup>
          <h:outputText value="#{commonMessages.cancel_question_info_regrade} #{commonMessages.cancel_question_info_no_undo}" />
        </h:panelGroup>
      </h:panelGroup>
      <h:panelGroup styleClass="modal-footer act" layout="block">
        <h:commandButton styleClass="active" type="submit" id="cancelItemTotal" action="questionScores"
            value="#{commonMessages.cancel_question_reduce_total}">
          <f:actionListener type="org.sakaiproject.tool.assessment.ui.listener.author.ItemCancellationListener" />
          <f:param name="outcome" value="questionScores"/>
          <f:param name="itemId" value="ITEM_ID"/>
          <f:param name="cancellation" value="10"/>
          <f:param name="regrade" value="true"/>
        </h:commandButton>
        <h:commandButton styleClass="button me-0 me-lg-1" type="submit" id="cancelItemDistribute" action="questionScores"
            value="#{commonMessages.cancel_question_distribute_points}">
          <f:actionListener type="org.sakaiproject.tool.assessment.ui.listener.author.ItemCancellationListener" />
          <f:param name="outcome" value="questionScores"/>
          <f:param name="itemId" value="ITEM_ID"/>
          <f:param name="cancellation" value="20"/>
          <f:param name="regrade" value="true"/>
        </h:commandButton>
        <button type="button" class="button mt-1 mt-lg-0" data-bs-dismiss="modal">
          <h:outputText value="#{commonMessages.cancel_question_cancel}" />
        </button>
      </h:panelGroup>
    </h:panelGroup>
  </h:panelGroup>
</div>

</h:form>
</div>
  <!-- end content -->
      </body>
    </html>
  </f:view>
