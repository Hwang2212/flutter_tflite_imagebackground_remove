package main.java.sq.flutter.removebackground;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.SystemClock;
import android.renderscript.Allocation;
import android.renderscript.Element;
import android.renderscript.RenderScript;
import android.renderscript.ScriptIntrinsicYuvToRGB;
import android.renderscript.Type;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import org.tensorflow.lite.DataType;
import org.tensorflow.lite.Interpreter;
import org.tensorflow.lite.Tensor;

import org.tensorflow.lite.gpu.GpuDelegate;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.PriorityQueue;
import java.util.Vector;

public class RemoveBackgroundPlugin implements MethodCallHandler{
    private final Registrar mRegistrar;
    private Interpreter interpreter;
    private boolean interpreterBusy = false;
    private int inputSize = 0;
    private Vector<String> labels;
    float[][] labelProb;
    private static final int BYTES_PER_CHANNEL = 4;

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "removebackground");
        channel.setMethodCallHandler(new TflitePlugin(registrar));
      }
    
    private TflitePlugin(Registrar registrar) {
        this.mRegistrar = registrar;
      }
    
      @Override
      public void onMethodCall(MethodCall call, Result result){
        if (call.method.equals("performSegmentation")) {
            try {
                String res = "";
                result.success(res);
            } catch (Exception e) {
                result.error("Failed to load model", e.getMessage(), e);
            }
        } else {
            
        }
      }
    
      private String loadModel(HashMap args) throws IOException {
        String model = args.get("model").toString();
        Object isAssetObj = args.get("isAsset");
        boolean isAsset = isAssetObj == null ? false : (boolean) isAssetObj;
        MappedByteBuffer buffer = null;
        String key = null;
        AssetManager assetManager = null;
        if (isAsset) {
          assetManager = mRegistrar.context().getAssets();
          key = mRegistrar.lookupKeyForAsset(model);
          AssetFileDescriptor fileDescriptor = assetManager.openFd(key);
          FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
          FileChannel fileChannel = inputStream.getChannel();
          long startOffset = fileDescriptor.getStartOffset();
          long declaredLength = fileDescriptor.getDeclaredLength();
          buffer = fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
        } else {
          FileInputStream inputStream = new FileInputStream(new File(model));
          FileChannel fileChannel = inputStream.getChannel();
          long declaredLength = fileChannel.size();
          buffer = fileChannel.map(FileChannel.MapMode.READ_ONLY, 0, declaredLength);
        }
    
        int numThreads = (int) args.get("numThreads");
        Boolean useGpuDelegate = (Boolean) args.get("useGpuDelegate");
        if (useGpuDelegate == null) {
          useGpuDelegate = false;
        }
    
        final Interpreter.Options tfliteOptions = new Interpreter.Options();
        tfliteOptions.setNumThreads(numThreads);
        if (useGpuDelegate){
          GpuDelegate delegate = new GpuDelegate();
          tfliteOptions.addDelegate(delegate);
        }
        tfLite = new Interpreter(buffer, tfliteOptions);
    
        String labels = args.get("labels").toString();
    
        if (labels.length() > 0) {
          if (isAsset) {
            key = mRegistrar.lookupKeyForAsset(labels);
            loadLabels(assetManager, key);
          } else {
            loadLabels(null, labels);
          }
        }
    
        return "success";
      }


}
