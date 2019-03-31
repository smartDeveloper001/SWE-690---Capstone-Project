package com.alp.web

import com.alp.SLog
import io.reactivex.Observable
import io.reactivex.ObservableSource
import io.reactivex.ObservableTransformer
import io.reactivex.functions.Function
import retrofit2.Response
import retrofit2.adapter.rxjava2.Result


class ResultToResponseWithErrorHandlingTransformer<T>: ObservableTransformer<Result<T>, Response<*>> {
    val TAG:String = ResultToResponseWithErrorHandlingTransformer::class.java.name

    override fun apply(upstream: Observable<Result<T>>?): ObservableSource<Response<*>> {

        return upstream!!.flatMap(Function<Result<*>, Observable<Response<*>>> { result ->
            if ( result.response() == null) {
                SLog.e(TAG,"checkResultSuccess...result is empty")
                if ( result.error() != null) {
                    SLog.e(TAG,result.error()!!.toString())
                }
                return@Function Observable.error<Response<*>>(WebSdkErrorException("EmptyBody"))
            }
            if (result.isError) {
                SLog.e(TAG,"checkResultSuccess..." + result.isError)
                return@Function Observable.error<Response<*>>(WebSdkErrorException(result!!.error()!!.message!!))
            }

            if (result.response()!!.isSuccessful) {
                SLog.d(TAG,"checkResultSuccess..." + result.response()!!.isSuccessful)
                SLog.d(TAG,"checkResultSuccess...code..." + result.response()!!.code())
                Observable.just(result.response()!!)
            } else {
                SLog.e(TAG,"checkResultSuccess..." + result.response()!!.isSuccessful)

                val httpCode = result.response()!!.code()
                SLog.e(TAG,"checkResultSuccess...httpCode..." + httpCode)
                var errorBodyString= result.response()!!.errorBody()!!.string()
                return@Function Observable.error<Response<*>>(WebSdkErrorException(errorBodyString))
            }
    })
    }
}


