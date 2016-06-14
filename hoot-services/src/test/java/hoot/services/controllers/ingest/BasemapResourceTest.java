/*
 * This file is part of Hootenanny.
 *
 * Hootenanny is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * --------------------------------------------------------------------
 *
 * The following copyright notices are generated automatically. If you
 * have a new notice to add, please use the format:
 * " * @copyright Copyright ..."
 * This will properly maintain the copyright information. DigitalGlobe
 * copyrights will be updated automatically.
 *
 * @copyright Copyright (C) 2015, 2016 DigitalGlobe (http://www.digitalglobe.com/)
 */
package hoot.services.controllers.ingest;

import java.io.File;
import java.lang.reflect.Method;

import org.apache.commons.io.FileUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.experimental.categories.Category;

import hoot.services.HootProperties;
import hoot.services.UnitTest;


public class BasemapResourceTest {
    private static final String tileServerPath = HootProperties.getProperty("tileServerPath");
    private static final String ingestStagingPath = HootProperties.getProperty("ingestStagingPath");


    @BeforeClass
    public static void oneTimeSetup() {
        Assert.assertNotNull(tileServerPath);
        Assert.assertTrue(!tileServerPath.isEmpty());

        Assert.assertNotNull(ingestStagingPath);
        Assert.assertTrue(!ingestStagingPath.isEmpty());
    }

    @Test
    @Category(UnitTest.class)
    public void TestgetBasemapList() throws Exception {
        File f = new File(tileServerPath + "/BASEMAP/TestMap");
        FileUtils.forceMkdir(f);

        JSONObject cont = new JSONObject();
        cont.put("jobid", "123-456-789");
        cont.put("path", "/projects/hoot/ingest/processed/BASEMAP/TestMap");

        File file = new File(ingestStagingPath + "/BASEMAP/TestMap.enabled");
        FileUtils.writeStringToFile(file, cont.toJSONString());

        File f2 = new File(tileServerPath + "/BASEMAP/TestMap2");
        FileUtils.forceMkdir(f2);

        File file2 = new File(ingestStagingPath + "/BASEMAP/TestMap2.enabled");
        FileUtils.writeStringToFile(file2, cont.toJSONString());

        Method getBasemapListHelperMethod = BasemapResource.class.getDeclaredMethod("getBasemapListHelper");
        getBasemapListHelperMethod.setAccessible(true);
        JSONArray res = (JSONArray) getBasemapListHelperMethod.invoke(null);

        boolean found = false;
        for (Object oMap : res) {
            JSONObject map = (JSONObject) oMap;
            if (map.get("name").toString().equals("TestMap")) {
                found = true;
                break;
            }
        }

        Assert.assertTrue(found);
        FileUtils.forceDelete(f);
        FileUtils.forceDelete(f2);
    }

    @Test
    @Category(UnitTest.class)
    public void TestToggleBasemap() throws Exception {
        File file = new File(ingestStagingPath + "/BASEMAP/controltest.enabled");
        FileUtils.touch(file);

        Method toggleBaseMapMethod = BasemapResource.class.getDeclaredMethod("toggleBaseMap", String.class, boolean.class);
        toggleBaseMapMethod.setAccessible(true);

        toggleBaseMapMethod.invoke(null, "controltest", false);
        file = new File(ingestStagingPath + "/BASEMAP/controltest.disabled");
        Assert.assertTrue(file.exists());

        toggleBaseMapMethod.invoke(null, "controltest", true);
        file = new File(ingestStagingPath + "/BASEMAP/controltest.enabled");
        Assert.assertTrue(file.exists());

        FileUtils.forceDelete(file);
    }

    @Test
    @Category(UnitTest.class)
    public void TestDeleteBasemap() throws Exception {
        String testMapName = "testmap";

        File dir = new File(tileServerPath + "/BASEMAP/" + testMapName);
        FileUtils.forceMkdir(dir);

        Assert.assertTrue(dir.exists());

        File controlFile = new File(ingestStagingPath + "/BASEMAP/" + testMapName + ".enabled");
        FileUtils.touch(controlFile);
        Assert.assertTrue(controlFile.exists());

        Method deleteBaseMapMethod = BasemapResource.class.getDeclaredMethod("deleteBaseMap", String.class);
        deleteBaseMapMethod.setAccessible(true);
        deleteBaseMapMethod.invoke(null, testMapName);

        Assert.assertFalse(dir.exists());
        Assert.assertFalse(controlFile.exists());
    }
}
