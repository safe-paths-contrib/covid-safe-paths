import PropTypes from 'prop-types';
import React, { useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import {
  BackHandler,
  NativeModules,
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  TouchableOpacity,
  View,
} from 'react-native';
import RNFS from 'react-native-fs';
import LinearGradient from 'react-native-linear-gradient';
import Share from 'react-native-share';
import { SvgXml } from 'react-native-svg';
import RNFetchBlob from 'rn-fetch-blob';

import close from './../assets/svgs/close';
import exportIcon from './../assets/svgs/export';
import { isPlatformiOS } from './../Util';
import { Typography } from '../components/Typography';
import Colors from '../constants/colors';
import fontFamily from '../constants/fonts';
import { Theme } from '../constants/themes';

const base64 = RNFetchBlob.base64;

export const ExportScreen = ({ navigation }) => {
  const { t } = useTranslation();
  function handleBackPress() {
    navigation.goBack();
    return true;
  }

  useEffect(() => {
    BackHandler.addEventListener('hardwareBackPress', handleBackPress);

    return function cleanup() {
      BackHandler.removeEventListener('hardwareBackPress', handleBackPress);
    };
  });

  function backToMain() {
    navigation.goBack();
  }

  async function onShare() {
    try {
      let locationData = await NativeModules.SecureStorageManager.getLocations();
      let nowUTC = new Date().toISOString();
      let unixtimeUTC = Date.parse(nowUTC);

      let options = {};
      let jsonData = JSON.stringify(locationData);
      const title = 'COVIDSafePaths.json';
      const filename = unixtimeUTC + '.json';
      const message = 'Here is my location log from COVID Safe Paths.';
      if (isPlatformiOS()) {
        const url = RNFS.DocumentDirectoryPath + '/' + filename;
        await RNFS.writeFile(url, jsonData, 'utf8')
          .then(() => {
            options = {
              activityItemSources: [
                {
                  placeholderItem: { type: 'url', content: url },
                  item: {
                    default: { type: 'url', content: url },
                  },
                  subject: {
                    default: title,
                  },
                  linkMetadata: { originalUrl: url, url, title },
                },
              ],
            };
          })
          .catch(err => {
            console.log(err.message);
          });
      } else {
        jsonData = 'data:application/json;base64,' + base64.encode(jsonData);
        options = {
          title,
          subject: title,
          url: jsonData,
          message: message,
          filename: filename,
        };
      }
      await Share.open(options)
        .then(res => {
          console.log(res);
        })
        .catch(err => {
          console.log(err);
          console.log(err.message, err.code);
        });
      if (isPlatformiOS()) {
        // eslint-disable-next-line no-undef
        await RNFS.unlink(url);
      }
    } catch (error) {
      console.log(error.message);
    }
  }

  return (
    <Theme use='violet'>
      <StatusBar
        barStyle='light-content'
        backgroundColor={Colors.VIOLET_BUTTON}
        translucent={false}
      />
      <SafeAreaView style={styles.topSafeAreaContainer} />
      <SafeAreaView style={styles.bottomSafeAreaContainer}>
        <LinearGradient
          start={{ x: 0, y: 0 }}
          end={{ x: 0, y: 1 }}
          colors={[Colors.VIOLET_BUTTON, Colors.VIOLET_BUTTON_DARK]}
          style={{ flex: 1, height: '100%' }}>
          <View style={styles.headerContainer}>
            <TouchableOpacity
              style={styles.backArrowTouchable}
              onPress={() => backToMain()}>
              <SvgXml style={styles.backArrow} xml={close} />
            </TouchableOpacity>
          </View>

          <ScrollView contentContainerStyle={styles.contentContainer}>
            <View style={styles.main}>
              <Typography use='headline2' style={styles.exportSectionTitles}>
                {t('share.title')}
              </Typography>
              <Typography use='body1' style={styles.exportSectionPara}>
                {t('share.paragraph_first')}
              </Typography>
              <Typography use='body1' style={styles.exportSectionPara}>
                {t('share.paragraph_second')}
              </Typography>

              <TouchableOpacity style={styles.exportButton} onPress={onShare}>
                <Typography style={styles.exportButtonText}>
                  {t('share.button_text')}
                </Typography>
                <SvgXml style={styles.exportIcon} xml={exportIcon} />
              </TouchableOpacity>
            </View>
          </ScrollView>
        </LinearGradient>
      </SafeAreaView>
    </Theme>
  );
};

const styles = StyleSheet.create({
  // Container covers the entire screen
  topSafeAreaContainer: {
    flex: 0,
    backgroundColor: Colors.VIOLET_BUTTON,
  },
  bottomSafeAreaContainer: {
    flex: 1,
    backgroundColor: Colors.VIOLET_BUTTON_DARK,
  },
  headerContainer: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
  },
  backArrowTouchable: {
    width: 60,
    height: 55,
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 1,
  },
  backArrow: {
    height: 18,
    width: 18,
  },
  contentContainer: {
    flexDirection: 'column',
    width: '100%',
    flex: 1,
    paddingHorizontal: 26,
  },
  exportSectionTitles: {
    marginTop: 9,
    fontWeight: 'normal',
    fontFamily: fontFamily.primaryMedium,
  },
  exportSectionPara: {
    marginTop: 22,
  },

  exportButton: {
    backgroundColor: Colors.WHITE,
    flexDirection: 'row',
    height: 64,
    borderRadius: 8,
    marginTop: 48,
    justifyContent: 'space-around',
    alignItems: 'center',
  },
  exportButtonText: {
    color: Colors.VIOLET,
    fontSize: 20,
    fontFamily: fontFamily.primaryMedium,
  },
  exportIcon: {
    width: 16,
    height: 21,
  },
  main: {
    flex: 1,
    paddingTop: 48,
  },
});

ExportScreen.propTypes = {
  shareButtonDisabled: PropTypes.bool,
};

ExportScreen.defaultProps = {
  shareButtonDisabled: true,
};
