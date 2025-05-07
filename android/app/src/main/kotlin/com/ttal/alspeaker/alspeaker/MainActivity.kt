package com.ttal.alspeaker.alspeaker

import io.flutter.embedding.android.FlutterActivity
import org.opencv.android.OpenCVLoader
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.opencv.core.*
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import java.io.File
import org.opencv.objdetect.CascadeClassifier
import android.content.Context
import java.io.FileOutputStream
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.util.Base64
import java.io.ByteArrayOutputStream
import org.opencv.android.Utils

import kotlin.random.Random
import io.flutter.embedding.engine.FlutterEngine


class MainActivity: FlutterActivity() {
    private val CHANNEL = "opencv"
    val calibrationData = mutableMapOf<String, Point>()
    private lateinit var faceCascade: CascadeClassifier
    private lateinit var eyeCascade: CascadeClassifier
    
    override fun onStart() {
        super.onStart()
        OpenCVLoader.initDebug()
        Log.d("infoW" ,"openCV Loaded!")
        println("infoW - openCV Loaded!")

        loadCalibrationData()
    }

    private fun initall() {
        onStart()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        println("infoW - onCreate() calisti!")
        OpenCVLoader.initDebug()
        println("infoW - openCV Loaded!2")
    }
    
    override fun onResume() {
        super.onResume()
        println("infoW - onResume() calisti!")
    }

    private fun loadCalibrationData() {
        // Kaydedilmiş göz resimlerini ve yönleri kontrol et
        val directions = listOf("straight", "rightup", "leftup", "up", "down" ,"rightdown", "leftdown")
        
        // Her yön için uygun kalibrasyon resmini işleyin
        for (direction in directions) {
            val eyeImagePath = getEyeImagePathForDirection(direction)
            
            if ((File(eyeImagePath).exists())) {
                calibrateEyeDirection(eyeImagePath, direction)
            }
        }
    }

    private fun getEyeImagePathForDirection(direction: String): String {
        val directory = context.filesDir
        return "${directory.path}/${direction}_cropped.jpg"
    }

    fun copyAssetToCache(context: Context, assetName: String): String {
        val assetManager = context.assets
        val file = File(context.cacheDir, assetName)  // Dosyanın kopyalanacağı yer
    
        if (!file.exists()) {
            assetManager.open(assetName).use { inputStream ->
                FileOutputStream(file).use { outputStream ->
                    inputStream.copyTo(outputStream)
                }
            }
        }
    
        return file.absolutePath
    }

    fun loadCascadeClassifiers(context: Context): Pair<CascadeClassifier, CascadeClassifier> {
        // Cache'e dosyaları kopyala
        val faceCascadePath = copyAssetToCache(context, "haarcascade_frontalface_default.xml")
        val eyeCascadePath = copyAssetToCache(context, "haarcascade_eye.xml")
    
        // Null olmasi garantilenen CascadeClassifier nesnelerini oluştur
        val faceCascade = CascadeClassifier(faceCascadePath) ?: throw NullPointerException("Face Cascade is null")
        val eyeCascade = CascadeClassifier(eyeCascadePath) ?: throw NullPointerException("Eye Cascade is null")
    
        return Pair(faceCascade, eyeCascade)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        println("infoW - configureFlutterEngine is worked! (${CHANNEL})")
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "processImage" -> {
                    println("infoW - processImage is worked! - 1")
                    val path = call.argument<String>("path")
                    val eye = call.argument<String>("eye")
                    val direction = call.argument<String>("direction")
                    println("infoW - processImage is worked! - 2")
                    if (path != null && eye != null && direction != null) {
                        val croppedPath = processImage(path, eye, direction)
                        result.success(croppedPath)
                        println("infoW - processImage is succesfully worked!")
                    } else {
                        println("infoW - processImage is failed!")
                        result.error("INVALID_ARGS", "Eksik argümanlar", null)
                    }
                }
                "detectEye" -> {
                    println("infoW - detectEye is worked!")
                    val path = call.argument<String>("imagePath")
                    if (path != null) {
                        val detectionResult = detectEyeDirection(path)
                        result.success(detectionResult)
                    } else {
                        result.error("INVALID_ARGS", "Eksik argümanlar", null)
                    }
                }
                "initall" -> {
                    println("infoW - detectEye is worked!")
                    initall()
                    result.success("succes")
                }
                "detectFaces" -> {
                    println("infoW - detectFaces is worked!!!!")
                    val imageBase64 = call.argument<String>("image")!!
                    val processedImage = detectFaces(imageBase64)
                    result.success(processedImage)
                }
                else -> {
                    println("infoW - not Implemented!")
                    result.notImplemented()
                }
            }
        }
    }

    private fun detectFaces(imageBase64: String): String {
        try {
            val (faceCascade, eyeCascade) = loadCascadeClassifiers(this)

            val imageBytes = Base64.decode(imageBase64, Base64.DEFAULT)
            val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)

            val mat = Mat()
            val converted = Mat()
            val gray = Mat()

            // Bitmap'i OpenCV Mat formatına çevir
            Utils.bitmapToMat(bitmap, mat)
            Imgproc.cvtColor(mat, converted, Imgproc.COLOR_RGBA2BGR)
            Imgproc.cvtColor(converted, gray, Imgproc.COLOR_BGR2GRAY)

            val faces = MatOfRect()
            faceCascade.detectMultiScale(gray, faces, 1.1, 4, 0, Size(50.0, 50.0), Size())

            // Yüzleri kutu içine al
            for (rect in faces.toArray()) {
                Imgproc.rectangle(mat, rect.tl(), rect.br(), Scalar(255.0, 0.0, 0.0), 3)

                val roiGray = gray.submat(rect)
                val roiMat = mat.submat(rect)

                val eyes = MatOfRect()
                eyeCascade.detectMultiScale(roiGray, eyes, 1.1, 3, 0, Size(20.0, 20.0), Size())

                for (eye in eyes.toArray()) {
                    val eyeX = eye.x + rect.x
                    val eyeY = eye.y + rect.y
                    val eyeRect = Rect(eyeX, eyeY, eye.width, eye.height)
                    Imgproc.rectangle(mat, eyeRect.tl(), eyeRect.br(), Scalar(0.0, 255.0, 0.0), 2)
                }
            }

            // İşlenmiş Mat'ı Bitmap'e çevir
            val outputBitmap = Bitmap.createBitmap(mat.cols(), mat.rows(), Bitmap.Config.ARGB_8888)
            Utils.matToBitmap(mat, outputBitmap)

            // Bitmap'i Base64 formatına çevirip Flutter'a geri gönder
            val outputStream = ByteArrayOutputStream()
            outputBitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
            val byteArray = outputStream.toByteArray()
            return Base64.encodeToString(byteArray, Base64.DEFAULT)

        } catch (e: Exception) {
            Log.e("FaceDetection", "Error: ${e.message}")
            return ""
        }
    }

    private fun cropEye(roiColor: Mat, eyeRects: Array<Rect>, selectedEye: String): Mat? {
        if (eyeRects.isEmpty()) {
            println("infoW - cropEye cant find eyes!")
            return null
        }
    
        // Sağ veya sol göz için indeks belirle
        val eyeIndex = when {
            selectedEye == "right" && eyeRects.size >= 1 -> 0
            selectedEye == "left" && eyeRects.size >= 2 -> 1
            else -> {
                println("infoW - cropEye couldn't determine eye index!")
                return null
            }
        }
    
        val eye = eyeRects[eyeIndex]
    
        // Sabit boyutlar (TÜM göz resimleri aynı boyutta olacak)
        val fixedWidth = 100
        val fixedHeight = 60
    
        // Gözün merkezini al
        val centerX = eye.x + eye.width / 2
        val centerY = eye.y + eye.height / 2
    
        // Yeni ROI'yi oluştur (Gözün ortada olması için)
        val startX = maxOf(centerX - fixedWidth / 2, 0)
        val startY = maxOf(centerY - fixedHeight / 2, 0)
        val endX = minOf(startX + fixedWidth, roiColor.cols())
        val endY = minOf(startY + fixedHeight, roiColor.rows())
    
        val eyeCrop = roiColor.submat(Rect(startX, startY, endX - startX, endY - startY))
    
        // Sabit boyuta resize et
        val eyeCropResized = Mat()
        Imgproc.resize(eyeCrop, eyeCropResized, Size(fixedWidth.toDouble(), fixedHeight.toDouble()))
    
        return eyeCropResized
    }

    private fun processImage(imagePath: String, selectedEye: String, direction: String): String? {
        val image = Imgcodecs.imread(imagePath)
        val gray = Mat()
        Imgproc.cvtColor(image, gray, Imgproc.COLOR_BGR2GRAY)
    
        // Yüz ve göz tespiti için CascadeClassifier
        val (faceCascade, eyeCascade) = loadCascadeClassifiers(this)
    
        val faces = MatOfRect()
        faceCascade.detectMultiScale(
            gray,
            faces,
            1.1,   // scaleFactor (görüntü boyutlarını değiştirirken yapılan küçülme oranı)
            3,     // minNeighbors (yüzler için minimum komşu sayısı)
            30,    // minSize (yüzlerin minimum boyutu)
            Size(30.0, 30.0)  // minSize boyutu
        )
    
        val faceArray = faces.toArray()
    
        // Eğer birden fazla yüz algılandıysa null döndür
        if (faceArray.size != 1) {
            println("infoW - processImage detected multiple or no faces! (${faceArray.size})")
            return null
        }
    
        // Tek bir yüz olduğu kesin, işleme devam edebiliriz
        val face = faceArray[0]
        val roiGray = gray.submat(face)
        val roiColor = image.submat(face)
    
        val eyes = MatOfRect()
        eyeCascade.detectMultiScale(
            roiGray,    // Yüz bölgesi (ROI)
            eyes,       // Tespit edilen gözlerin saklanacağı MatOfRect
            1.1,        // scaleFactor
            3,          // minNeighbors (gözleri doğru tespit etmek için gereken minimum komşu sayısı)
            30,         // minSize (gözlerin minimum boyutu)
            Size(20.0, 20.0)  // minSize boyutu
        )
    
        val eyeRects = eyes.toArray()
    
        // Eğer 2'den fazla göz algılandıysa null döndür
        if (eyeRects.size > 2) {
            println("infoW - processImage detected too many eyes!")
            return null
        }
    
        // Göz kırpma fonksiyonunu çağır ve kaydet
        val eyeCropResized = cropEye(roiColor, eyeRects, selectedEye) ?: return null
    
        val outputPath = getEyeImagePathForDirection(direction)
        Imgcodecs.imwrite(outputPath, eyeCropResized)
    
        calibrateEyeDirection(outputPath, direction)
    
        println("infoW - processImage returned outputPath!")
        return outputPath
    }

    fun calibrateEyeDirection(eyeImagePath: String, direction: String) {
        val eyeImage = Imgcodecs.imread(eyeImagePath)
        val eyeGray = Mat()
        Imgproc.cvtColor(eyeImage, eyeGray, Imgproc.COLOR_BGR2GRAY)
    
        // Gözün merkezini bul
        val moments = Imgproc.moments(eyeGray)
        val centerX = moments.m10 / moments.m00
        val centerY = moments.m01 / moments.m00
    
        // Koordinatları kaydet
        calibrationData[direction] = Point(centerX, centerY)
        println("infoW - ${direction} Kalibrasyonu Yapildi! (${eyeImagePath})")
    }

    fun isEyeClosed(eyeGray: Mat): Boolean {
        // Göz resmini bulanıklaştır
        val blurred = Mat()
        Imgproc.GaussianBlur(eyeGray, blurred, Size(5.0, 5.0), 0.0)
    
        // Piksel yoğunluklarının ortalamasını hesapla
        val meanIntensity = Core.mean(blurred).`val`[0]
    
        
        return meanIntensity > 250.0  // Göz kapalıysa daha homojen bir parlaklık olur
    }

    fun detectEyeDirection(eyeImagePath: String): Map<String, Any> {
        val frame = Imgcodecs.imread(eyeImagePath)
        if (frame.empty()) {
            println("infoW - Cannot read image file!")
            return mapOf(
                "direction" to "straight",
                "overalloss" to "0.00"
            )
        }
    
        val grayFrame = Mat()
        Imgproc.cvtColor(frame, grayFrame, Imgproc.COLOR_BGR2GRAY)
    
        val (faceCascade, eyeCascade) = loadCascadeClassifiers(this)

        val faces = MatOfRect()
        faceCascade.detectMultiScale(grayFrame, faces)
    
        val faceArray = faces.toArray()
    
        // Eğer birden fazla yüz algılandıysa null döndür
        if (faceArray.size != 1) {
            println("infoW - processImage detected multiple or no faces!")
            return mapOf(
                "direction" to "straight",
                "overalloss" to "0.00"
            )
        }

        val eyeRects = MatOfRect()
        eyeCascade.detectMultiScale(grayFrame, eyeRects)
        val eyeArray = eyeRects.toArray()
    
        if (eyeArray.isEmpty()) {
            println("infoW - No eyes detected!")
            return mapOf(
                "direction" to "straight",
                "overalloss" to "0.00"
            )
        }
    
        val selectedEye = if (eyeArray.size == 1) "right" else if (Random.nextBoolean()) "right" else "left"
        val eyeImage = cropEye(frame, eyeArray, selectedEye) ?: return mapOf(
            "direction" to "straight",
            "overalloss" to "0.00"
        )

        val eyeGray = Mat()
        Imgproc.cvtColor(eyeImage, eyeGray, Imgproc.COLOR_BGR2GRAY)
    
        if (isEyeClosed(eyeGray)) {
            return mapOf(
                "direction" to "closed",
                "overalloss" to "0.00"
            )
        }

        
    
        val moments = Imgproc.moments(eyeGray)
        val centerX = moments.m10 / moments.m00
        val centerY = moments.m01 / moments.m00
    
        val eyeCenter = Point(centerX, centerY)
        var closestDirection = ""
        var minDistance = Double.MAX_VALUE
        var overalloss = ""
    
        for ((dir, calibrationPoint) in calibrationData) {
            val distance = center(eyeCenter, calibrationPoint)
            if (distance < minDistance) {
                minDistance = distance
                closestDirection = dir
            }
            if (dir == "straight") {
                overalloss = distance.toString()
            }
        }
    
        return mapOf(
            "direction" to closestDirection,
            "overalloss" to overalloss
        )
    }
    
    // İki nokta arasındaki mesafeyi hesaplayan fonksiyon
    fun center(p1: Point, p2: Point): Double {
        return Math.sqrt(Math.pow(p1.x - p2.x, 2.0) + Math.pow(p1.y - p2.y, 2.0))
    }

    fun testImage(inputFrame: Mat): Mat {
        val outputFrame = inputFrame.clone() // Görüntüyü kopyala
    
        // Nokta Ekleme
        Imgproc.circle(outputFrame, Point(100.0, 200.0), 5, Scalar(0.0, 0.0, 255.0), -1)
    
        // Çizgi ekleme 
        Imgproc.line(outputFrame, Point(50.0, 50.0), Point(200.0, 200.0), Scalar(0.0, 0.0, 255.0), 2)
    
        return outputFrame
    }
}