/**
 * Copyright (c) 2003-2017 The Apereo Foundation
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
package org.sakaiproject.gradebookng.tool.actions;

import org.apache.wicket.injection.Injector;

abstract public class InjectableAction implements Action {
	public InjectableAction() {
		// inject Spring dependencies into this class and derived instances
		Injector.get().inject(this);
	}

	protected String currentGradebookUid;
	protected String currentSiteId;

	public void setCurrentGradebookAndSite(String gUid, String siteId) {
		currentGradebookUid = gUid;
		currentSiteId = siteId;
	}

}
