import i18n from '../i18n'

export default {
    get HAVE_NO_RESULT() { return i18n.t('common.na') },
    PAGE: {
        LOGIN: '/login',
    },
    STORAGE_KEY: {
        TOKEN: 'TOKEN',
        PUBLIC_KEY: 'PUBLIC_KEY',
        USER_TYPE: 'USER_TYPE'
    },
    Lang: {
        'zh_cn': 'zh_cn', 'zh_tw': 'zh_tw', 'en': 'en'
    },
    FONT_SIZE: {
        'big': 'big',
        'normal': 'normal',
    }, // 获取map中的某key
    get(map, key) {
        return map[key] || i18n.t('common.na')
    }
}
