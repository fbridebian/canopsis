import { isUndefined } from 'lodash';

/**
 * Links collection comparator by label
 *
 * @returns {number}
 */
export const linksCollectionComparatorByLabel = (a, b) => {
  if (a.label > b.label) {
    return 1;
  }

  if (a.label < b.label) {
    return -1;
  }

  return 0;
};

/**
 * Harmonize links for special category
 *
 * @param {AlarmLinks} [links = {}]
 * @param {string} [category]
 * @returns {AlarmLink[]}
 */
export const harmonizeCategoryLinks = (links = {}, category) => {
  if (isUndefined(category) || !links[category]) {
    return [];
  }

  return links[category].sort(linksCollectionComparatorByLabel);
};

/**
 * Harmonize links for all categories
 *
 * @param {AlarmLinks} [links = {}]
 * @returns {Object<string, AlarmLink[]>}
 */
export const harmonizeCategoriesLinks = (links = {}) => Object.keys(links ?? {})
  .reduce((acc, category) => {
    acc[category] = harmonizeCategoryLinks(links, category);

    return acc;
  }, {});

/**
 * Get link rule link action type
 *
 * @param {LinkRuleLink} link
 * @returns {string}
 */
export const getLinkRuleLinkActionType = (link = {}) => [link.rule_id, link.icon_name, link.label].join('.');

/**
 * Get flatten alarm links
 *
 * @param {AlarmLinks} [links = {}]
 * @returns {AlarmLink[]}
 */
export const harmonizeLinks = (links = {}) => Object.values(links)
  .flat()
  .sort(linksCollectionComparatorByLabel);

/**
 * Get filtered links for alarms
 *
 * @param {Alarm[]} alarms
 * @returns {AlarmLink[]}
 */
export const harmonizeAlarmsLinks = (alarms = []) => {
  const links = alarms
    .map(alarm => harmonizeLinks(alarm.links).filter(link => !!link.rule_id));

  if (links.length === 0) {
    return [];
  }

  const linksByKeys = {};
  const lastIndexesByRuleIds = {};

  links.forEach((itemLinks, index) => {
    itemLinks.forEach((link) => {
      const key = getLinkRuleLinkActionType(link);

      if (!linksByKeys[key]) {
        linksByKeys[key] = link;
      }

      if (!index) {
        lastIndexesByRuleIds[link.rule_id] = 0;
        return;
      }

      if (!lastIndexesByRuleIds[link.rule_id]) {
        return;
      }

      if (lastIndexesByRuleIds[link.rule_id] - index > 1) {
        delete lastIndexesByRuleIds[link.rule_id];
        return;
      }

      lastIndexesByRuleIds[link.rule_id] = index;
    });
  });

  return Object.values(linksByKeys)
    .filter(link => !link.single && !isUndefined(lastIndexesByRuleIds[link.rule_id]))
    .sort(linksCollectionComparatorByLabel);
};
