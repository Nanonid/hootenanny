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
 * @copyright Copyright (C) 2005 VividSolutions (http://www.vividsolutions.com/)
 * @copyright Copyright (C) 2015 DigitalGlobe (http://www.digitalglobe.com/)
 */
#include "AngleHistogramExtractor.h"

// geos
#include <geos/geom/Geometry.h>

// hoot
#include <hoot/core/Factory.h>
#include <hoot/core/visitors/AngleHistogramVisitor.h>
#include <hoot/core/elements/ElementVisitor.h>
#include <hoot/core/util/GeometryConverter.h>

namespace hoot
{

HOOT_FACTORY_REGISTER(FeatureExtractor, AngleHistogramExtractor)

AngleHistogramExtractor::AngleHistogramExtractor()
{
}

Histogram* AngleHistogramExtractor::_createHistogram(const OsmMap& map, const ConstElementPtr& e)
  const
{
  Histogram* result = new Histogram(16);
  AngleHistogramVisitor v(*result, map);
  e->visitRo(map, v);
  return result;
}

double AngleHistogramExtractor::extract(const OsmMap& map, const ConstElementPtr& target,
  const ConstElementPtr& candidate) const
{
  auto_ptr<Histogram> h1(_createHistogram(map, target));
  auto_ptr<Histogram> h2(_createHistogram(map, candidate));
  h1->normalize();
  h2->normalize();

  const double diff = max(0.0, h1->diff(*h2));
  return 1.0 - diff;
}

}
