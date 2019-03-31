package com.alp.web

import android.os.Parcel
import android.os.Parcelable

internal class WebSdkErrorException : Exception {


    constructor(msg: String) : super(msg) {}

    protected constructor(`in`: Parcel) {}


}
