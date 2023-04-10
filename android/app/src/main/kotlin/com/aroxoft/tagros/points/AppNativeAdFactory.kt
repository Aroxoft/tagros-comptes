package com.aroxoft.tagros.points

import android.graphics.Color
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory


class AppNativeAdFactory(private val layoutInflater: LayoutInflater) : NativeAdFactory {
    companion object {
        const val TAG = "AppNativeAdFactory"
    }

    override fun createNativeAd(
        nativeAd: NativeAd, customOptions: Map<String?, Any?>?
    ): NativeAdView {

        // Create NativeAdView
        val adView: NativeAdView =
            layoutInflater.inflate(R.layout.app_native_ad, null) as NativeAdView

        Log.v(TAG, "The custom options are: $customOptions")

        // customization

        val bg: Int = Color.parseColor(customOptions?.get("background") as String? ?: "#ffffffff")
        val textColor: Int =
            Color.parseColor(customOptions?.get("textColor") as String? ?: "#ff000000")

        // Set background color
        adView.findViewById<ConstraintLayout>(R.id.ad_background).setBackgroundColor(bg)

        // headline
        val headlineView: TextView = adView.findViewById(R.id.ad_headline)
        nativeAd.headline?.let {
            headlineView.text = nativeAd.headline
            headlineView.setTextColor(textColor)
            adView.headlineView = headlineView
        } ?: run {
            // todo hide
        }

        // body
        val bodyView: TextView = adView.findViewById(R.id.ad_body)
        nativeAd.body?.let {
            bodyView.text = it
            bodyView.setTextColor(textColor)
            adView.bodyView = bodyView
        } ?: run {
            // todo hide
        }

        // icon
        val iconView: ImageView = adView.findViewById(R.id.ad_app_icon)
        nativeAd.icon?.let {
            iconView.setImageDrawable(nativeAd.icon?.drawable)
            adView.iconView = iconView
        } ?: run {
            // hide
            iconView.visibility = View.GONE
        }

        // rating
        val ratingView: RatingBar = adView.findViewById(R.id.ad_stars)
        nativeAd.starRating?.let {
            ratingView.rating = it.toFloat()
            adView.starRatingView = ratingView
        } ?: run {
            ratingView.numStars = 0
            // todo hide
        }

        // advertiser
        val advertiserView: TextView = adView.findViewById(R.id.ad_advertiser)
        nativeAd.advertiser?.let {
            advertiserView.text = it
            advertiserView.setTextColor(textColor)
            adView.advertiserView = advertiserView
        } ?: run {
            // todo hide
//            advertiserView                .visibility = View.GONE
        }

        // call to action
        val button: Button = adView.findViewById(R.id.ad_call_to_action)
        button.text = nativeAd.callToAction
        button.setBackgroundColor(textColor)
        button.setTextColor(bg)
        adView.callToActionView = button

        // register the nativeAd object
        adView.setNativeAd(nativeAd)
        return adView
    }
}
