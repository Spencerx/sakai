/**
 * Copyright (c) 2010-2017 The Apereo Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://opensource.org/licenses/ecl2
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/*
* Licensed to The Apereo Foundation under one or more contributor license
* agreements. See the NOTICE file distributed with this work for
* additional information regarding copyright ownership.
*
* The Apereo Foundation licenses this file to you under the Educational
* Community License, Version 2.0 (the "License"); you may not use this file
* except in compliance with the License. You may obtain a copy of the
* License at:
*
* http://opensource.org/licenses/ecl2.txt
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

package org.sakaiproject.roster.tool.entityprovider;

import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import org.sakaiproject.entitybroker.EntityReference;
import org.sakaiproject.entitybroker.EntityView;
import org.sakaiproject.entitybroker.entityprovider.annotations.EntityCustomAction;
import org.sakaiproject.entitybroker.entityprovider.capabilities.ActionsExecutable;
import org.sakaiproject.entitybroker.entityprovider.capabilities.AutoRegisterEntityProvider;
import org.sakaiproject.entitybroker.entityprovider.capabilities.Outputable;
import org.sakaiproject.entitybroker.entityprovider.extension.ActionReturn;
import org.sakaiproject.entitybroker.entityprovider.extension.Formats;
import org.sakaiproject.entitybroker.exception.EntityException;
import org.sakaiproject.entitybroker.util.AbstractEntityProvider;
import org.sakaiproject.roster.api.RosterData;
import org.sakaiproject.roster.api.RosterFunctions;
import org.sakaiproject.roster.api.RosterMember;
import org.sakaiproject.roster.api.SakaiProxy;
import org.sakaiproject.sitestats.api.SitePresenceTotal;
import org.sakaiproject.time.api.UserTimeService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

/**
 * <code>EntityProvider</code> to allow Roster to access site, membership, and
 * enrollment data for the current user. The provider respects Roster
 * permissions, so shouldn't expose any data the current user should not have
 * access to.
 * 
 * @author d.b.robinson@lancaster.ac.uk
 */
@Slf4j
public class RosterSiteEntityProvider extends AbstractEntityProvider implements
        AutoRegisterEntityProvider, ActionsExecutable, Outputable {

    public final static String ENTITY_PREFIX        = "roster-membership";
    public final static String DEFAULT_ID           = ":ID:";

    public final static String ERROR_INVALID_SITE   = "Invalid site ID";

    // key passed as parameters
    public final static String KEY_GROUP_ID                     = "groupId";
    public final static String KEY_ROLE_ID                      = "roleId";
    public final static String KEY_USER_IDS                     = "userIds";
    public final static String KEY_PAGE                         = "page";
    public final static String KEY_ALL                          = "all";
    public final static String KEY_ENROLLMENT_SET_ID            = "enrollmentSetId";
    public final static String KEY_ENROLLMENT_STATUS            = "enrollmentStatus";
    public final static String KEY_PAGE_SIZE                    = "pageSize";

    @Resource
    private SakaiProxy sakaiProxy;

    @Autowired
    @Qualifier("org.sakaiproject.time.api.UserTimeService")
    private UserTimeService userTimeService;

    @Override
    public String getEntityPrefix() {
        return ENTITY_PREFIX;
    }

    @EntityCustomAction(action = "get-membership", viewKey = EntityView.VIEW_SHOW)
    public Object getMembership(EntityReference reference, Map<String, Object> parameters) {

        String userId = developerHelperService.getCurrentUserId();

        if (userId == null) {
            throw new EntityException("You must be logged in to get the memberships", reference.getReference());
        }

        String siteId = reference.getId();

        if (null == siteId || DEFAULT_ID.equals(siteId)) {
            throw new EntityException(ERROR_INVALID_SITE, reference.getReference());
        }

        String groupId = null;
        if (parameters.containsKey(KEY_GROUP_ID)) {
            groupId = parameters.get(KEY_GROUP_ID).toString();
        }

        String roleId = null;
        if (parameters.containsKey(KEY_ROLE_ID)) {
            roleId = parameters.get(KEY_ROLE_ID).toString();
        }

        String enrollmentSetId = null;
        if (parameters.containsKey(KEY_ENROLLMENT_SET_ID)) {
            enrollmentSetId = parameters.get(KEY_ENROLLMENT_SET_ID).toString();
        }

        if (groupId != null && enrollmentSetId != null) {
            throw new EntityException("You can't specify a groupId AND an enrollmentSetId. One or the other, not both.", reference.getReference());
        }

        String enrollmentStatus = null;
        if (parameters.containsKey(KEY_ENROLLMENT_STATUS)) {
            enrollmentStatus = parameters.get(KEY_ENROLLMENT_STATUS).toString();
        }

        int page = 0;
        if (parameters.containsKey(KEY_PAGE)) {
            String pageString = parameters.get(KEY_PAGE).toString();
            try {
                page = Integer.parseInt(pageString);
            } catch (NumberFormatException nfe) {
                log.error("Invalid page number " + pageString + " supplied. The first page will be returned ...");
            }
        }

        boolean returnAll = Boolean.valueOf((String) parameters.get(KEY_ALL));

        List<RosterMember> membership
            = sakaiProxy.getMembership(userId, siteId, groupId, roleId, enrollmentSetId, enrollmentStatus);

        if (null == membership) {
            throw new EntityException("Unable to retrieve membership", reference.getReference());
        }

        int membershipsSize = membership.size();
        log.debug("memberships.size(): {}", membershipsSize);

        List<RosterMember> subList;

        int pageSize = 10;
        if (returnAll) {
            subList = membership;
        } else {
            if (parameters.containsKey(KEY_PAGE_SIZE)) {
                String strPageSize = parameters.get(KEY_PAGE_SIZE).toString();
                try {
                    pageSize = Integer.parseInt(strPageSize);
                } catch (NumberFormatException ex) {
                    log.error("Invalid page size: {}. Falling back to default page size of {}.", strPageSize, pageSize);
                }
            }

            int start  = page * pageSize;
            log.debug("start: {}", start);

            if (start >= membershipsSize) {
                return "{\"status\": \"END\"}";
            } else {
                int end = start + pageSize;

                log.debug("end: {}", end);

                if (end >= membershipsSize) {
                    end = membershipsSize;
                }

                subList = membership.subList(start, end);
            }
        }

        RosterData data = new RosterData();
        data.setMembers(subList);
        data.setMembersTotal(membershipsSize);
        data.setPageSize(pageSize);

        boolean showVisits = sakaiProxy.getShowVisits();

        Map<String, SitePresenceTotal> sitePresenceTotals = new HashMap<>();

        if (showVisits) {
            sitePresenceTotals = sakaiProxy.getPresenceTotalsForSite(siteId);
        }

        boolean viewSiteVisits
            = developerHelperService.isUserAllowedInEntityReference("/user/" + userId
                                                , RosterFunctions.ROSTER_FUNCTION_VIEWSITEVISITS
                                                , "/site/" + siteId);

        Map<String, Integer> roleCounts = new HashMap<>();

        for (RosterMember member : membership) {
            if (showVisits && viewSiteVisits) {
                String memberUserId = member.getUserId();
                if (sitePresenceTotals.containsKey(memberUserId)) {
                    SitePresenceTotal spt = sitePresenceTotals.get(memberUserId);
                    member.setTotalSiteVisits(spt.getTotalVisits());
                    member.setLastVisitTime(userTimeService.dateTimeFormat(spt.getLastVisitTime().toInstant(), null, null));
                }
            }
            String memberRoleId = member.getRole();
            if (!roleCounts.containsKey(memberRoleId)) {
                roleCounts.put(memberRoleId, 1);
            } else {
                roleCounts.put(memberRoleId, roleCounts.get(memberRoleId) + 1);
            }
        }

        data.setRoleCounts(roleCounts);

        return data;
    }

    @EntityCustomAction(action = "get-users", viewKey = EntityView.VIEW_SHOW)
    public Object getUsers(EntityReference reference, Map<String, Object> parameters) {

        String siteId = reference.getId();

        if (null == siteId || DEFAULT_ID.equals(siteId)) {
            throw new EntityException(ERROR_INVALID_SITE, reference.getReference());
        }

        String[] userIds = null;
        if (parameters.containsKey(KEY_USER_IDS)) {
            userIds = parameters.get(KEY_USER_IDS).toString().split(",");
        }

        if (null == userIds) {
            throw new EntityException("No user ids supplied", reference.getReference());
        }

        String enrollmentSetId = null;
        if (parameters.containsKey(KEY_ENROLLMENT_SET_ID)) {
            enrollmentSetId = parameters.get(KEY_ENROLLMENT_SET_ID).toString();
        }

        String groupId = null;
        if (parameters.containsKey(KEY_GROUP_ID)) {
            groupId = parameters.get(KEY_GROUP_ID).toString();
        }

        String roleId = null;
        if (parameters.containsKey(KEY_ROLE_ID)) {
            roleId = parameters.get(KEY_ROLE_ID).toString();
        }

        List<RosterMember> membership = new ArrayList<>();
        Map<String, Integer> roleCounts = new HashMap<>(1);

        for (String userId : userIds) {
            RosterMember member = sakaiProxy.getMember(siteId, userId, groupId, enrollmentSetId);
            if (member != null) {
                if(roleId != null) {
                    if(StringUtils.equals(member.getRole(), roleId)) {
                        membership.add(member);
                    }
                } else {
                    membership.add(member);
                }

                String role = member.getRole();
                if (!roleCounts.containsKey(role)) {
                    roleCounts.put(role, 1);
                } else {
                    roleCounts.put(role, roleCounts.get(role) + 1);
                }
            }
        }

        if (CollectionUtils.isEmpty(membership)) {
            throw new EntityException("Unable to retrieve membership", reference.getReference());
        }

        RosterData data = new RosterData();
        data.setMembers(membership);
        data.setMembersTotal(membership.size());
        data.setRoleCounts(roleCounts);

        return data;
    }

    @EntityCustomAction(action = "get-site", viewKey = EntityView.VIEW_SHOW)
    public Object getSite(EntityReference reference) {

        if (null == reference.getId() || DEFAULT_ID.equals(reference.getId())) {
            throw new EntityException(ERROR_INVALID_SITE, reference.getReference());
        }

        return sakaiProxy.getRosterSite(reference.getId());
    }

    @EntityCustomAction(action = "get-search-index", viewKey = EntityView.VIEW_SHOW)
    public ActionReturn getSearchIndex(EntityReference reference, Map<String, Object> actionParams) {

        String siteId = reference.getId();

        if (null == siteId || DEFAULT_ID.equals(siteId)) {
            throw new EntityException(ERROR_INVALID_SITE, reference.getReference());
        }

        String userId = developerHelperService.getCurrentUserId();
        String groupId = null;
        String roleId = null;
        String enrollmentSetId = null;
        String enrollmentStatus = "all";

        if(actionParams != null){
            groupId = (String) actionParams.get(KEY_GROUP_ID);
            roleId = (String) actionParams.get(KEY_ROLE_ID);
            enrollmentSetId = (String) actionParams.get(KEY_ENROLLMENT_SET_ID);
            if(actionParams.get(KEY_ENROLLMENT_STATUS) != null) {
                enrollmentStatus = (String) actionParams.get(KEY_ENROLLMENT_STATUS);
            }
        }
        return new ActionReturn(sakaiProxy.getSearchIndex(siteId, userId, groupId, roleId, enrollmentSetId, enrollmentStatus));
    }

    @Override
    public String[] getHandledOutputFormats() {
        return new String[] { Formats.JSON };
    }
}
