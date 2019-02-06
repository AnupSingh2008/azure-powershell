﻿// ----------------------------------------------------------------------------------
//
// Copyright Microsoft Corporation
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ----------------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using Microsoft.Rest.Azure;

namespace Microsoft.Azure.PowerShell.Cmdlets.Peering.Common
{
    /// <summary>
    /// 
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public static class ListNextLink<T>
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="resourcePage"></param>
        /// <param name="getNextLink"></param>
        /// <returns></returns>
        public static List<T> GetAllResourcesByPollingNextLink(IPage<T> resourcePage,
            Func<string, IPage<T>> getNextLink)
        {
            var resourceList = new List<T>();

            var nextPageLink = AddResourceToListAndReturnNextPageLink(resourcePage, resourceList);

            while (!string.IsNullOrEmpty(nextPageLink))
            {
                var nextVnetPage = getNextLink(nextPageLink);
                nextPageLink = AddResourceToListAndReturnNextPageLink(nextVnetPage, resourceList);
            }

            return resourceList;
        }

        private static string AddResourceToListAndReturnNextPageLink(IPage<T> resourcePage, List<T> resourceList)
        {
            foreach (var resource in resourcePage) resourceList.Add(resource);

            return resourcePage.NextPageLink;
        }
    }
}