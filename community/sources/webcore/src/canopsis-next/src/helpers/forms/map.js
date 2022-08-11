import { MAP_TYPES, MERMAID_THEMES } from '@/constants';
import uuid from '@/helpers/uuid';

/**
 * @typedef {Object} MapCommonFields
 * @property {string} name
 * @property {string} [_id]
 */

/**
 * @typedef {MapCommonFields} MapMermaidProperties
 * @property {string} theme
 * @property {string} code
 */

/**
 * @typedef {MapMermaidProperties} MapMermaidPropertiesForm
 */

/**
 * @typedef {MapCommonFields} MapMermaid
 * @property {'mermaid'} type
 * @property {MapMermaidProperties} properties
 */

/**
 * @typedef {MapCommonFields} MapGeoPoint
 * @property {string} _id
 * @property {string} link
 * @property {string} entity
 * @property {Object} coordinate
 */

/**
 * @typedef {Object} MapGeoProperties
 * @property {MapGeoPoint} points
 */

/**
 * @typedef {MapGeoProperties} MapGeoPropertiesForm
 */

/**
 * @typedef {MapCommonFields} MapGeo
 * @property {'geo'} type
 * @property {MapGeoProperties} properties
 */

/**
 * @typedef {Object} MapFlowchartProperties
 */

/**
 * @typedef {MapFlowchartProperties} MapFlowchartPropertiesForm
 */

/**
 * @typedef {MapCommonFields} MapFlowchart
 * @property {'flowchart'} type
 * @property {MapFlowchartProperties} properties
 */

/**
 * @typedef {Object} MapTreeOfDependenciesProperties
 */

/**
 * @typedef {MapTreeOfDependenciesProperties} MapTreeOfDependenciesPropertiesForm
 */

/**
 * @typedef {MapCommonFields} MapTreeOfDependencies
 * @property {'treeOfDependencies'} type
 * @property {MapTreeOfDependenciesProperties} properties
 */

/**
 * @typedef {MapMermaid} Map
 */

/**
 * @typedef {MapMermaid} MapForm
 */

/**
 * Convert geomap point to form object
 *
 * @param {MapGeoPoint} [point = {}]
 * @returns {MapGeoPoint}
 */
export const geomapPointToForm = (point = {}) => ({
  coordinate: point.coordinate ?? {
    lat: 0,
    lng: 0,
  },
  entity: point.entity ?? '',
  link: point.link,
  _id: uuid(),
});

/**
 * Convert map geo properties object to form
 *
 * @param {MapGeoProperties} [properties = {}]
 * @returns {MapGeoPropertiesForm}
 */
export const mapGeoPropertiesToForm = (properties = {}) => ({
  points: properties.points ?? [],
});

/**
 * Convert map flowchart properties object to form
 *
 * @param {MapFlowchartProperties} [properties = {}]
 * @returns {MapFlowchartPropertiesForm}
 */
export const mapFlowchartPropertiesToForm = properties => ({ ...properties });

/**
 * Convert map mermaid properties object to form
 *
 * @param {MapMermaidProperties} [properties = {}]
 * @returns {MapMermaidPropertiesForm}
 */
export const mapMermaidPropertiesToForm = (properties = {}) => ({
  theme: properties.theme ?? MERMAID_THEMES.default,
  code: properties.code ?? 'graph TB\na-->b',
});

/**
 * Convert map mermaid properties object to form
 *
 * @param {MapTreeOfDependenciesProperties} [properties = {}]
 * @returns {MapTreeOfDependenciesPropertiesForm}
 */
export const mapTreeOfDependenciesPropertiesToForm = properties => ({ ...properties });

/**
 * Convert map object to map form
 *
 * @param {Map} [map = {}]
 * @returns {MapForm}
 */
export const mapToForm = (map = {}) => {
  const type = map.type ?? MAP_TYPES.flowchart;

  const prepare = {
    [MAP_TYPES.geo]: mapGeoPropertiesToForm,
    [MAP_TYPES.flowchart]: mapFlowchartPropertiesToForm,
    [MAP_TYPES.mermaid]: mapMermaidPropertiesToForm,
    [MAP_TYPES.treeOfDependencies]: mapTreeOfDependenciesPropertiesToForm,
  }[type];

  return {
    name: map.name ?? '',
    type,
    properties: prepare(map.properties),
  };
};

/**
 * Convert map form to map
 *
 * @param {MapForm} form
 * @returns {Map}
 */
export const formToMap = form => ({ ...form });
