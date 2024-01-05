package test;

import org.deeplearning4j.datasets.iterator.impl.MnistDataSetIterator;
import org.deeplearning4j.nn.api.OptimizationAlgorithm;
import org.deeplearning4j.nn.conf.BackpropType;
import org.deeplearning4j.nn.conf.MultiLayerConfiguration;
import org.deeplearning4j.nn.conf.NeuralNetConfiguration;
import org.deeplearning4j.nn.conf.inputs.InputType;
import org.deeplearning4j.nn.conf.layers.*;
import org.deeplearning4j.nn.multilayer.MultiLayerNetwork;
import org.deeplearning4j.nn.weights.WeightInit;
import org.deeplearning4j.optimize.listeners.ScoreIterationListener;
import org.deeplearning4j.util.ModelSerializer;
import org.nd4j.linalg.activations.Activation;
import org.nd4j.linalg.api.ndarray.INDArray;
import org.nd4j.linalg.dataset.DataSet;
import org.nd4j.linalg.dataset.api.iterator.DataSetIterator;
import org.nd4j.linalg.dataset.api.preprocessor.DataNormalization;
import org.nd4j.linalg.dataset.api.preprocessor.ImagePreProcessingScaler;
import org.nd4j.linalg.factory.Nd4j;
import org.nd4j.linalg.learning.config.Adam;
import org.nd4j.linalg.lossfunctions.LossFunctions;

import java.awt.BorderLayout;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;

import org.deeplearning4j.datasets.iterator.impl.MnistDataSetIterator;
import org.deeplearning4j.nn.api.OptimizationAlgorithm;
import org.deeplearning4j.nn.conf.BackpropType;
import org.deeplearning4j.nn.conf.MultiLayerConfiguration;
import org.deeplearning4j.nn.conf.NeuralNetConfiguration;
import org.deeplearning4j.nn.conf.inputs.InputType;
import org.deeplearning4j.nn.conf.layers.*;
import org.deeplearning4j.nn.multilayer.MultiLayerNetwork;
import org.deeplearning4j.nn.weights.WeightInit;
import org.deeplearning4j.optimize.listeners.ScoreIterationListener;
import org.deeplearning4j.util.ModelSerializer;
import org.nd4j.linalg.activations.Activation;
import org.nd4j.linalg.api.ndarray.INDArray;
import org.nd4j.linalg.dataset.DataSet;
import org.nd4j.linalg.dataset.api.iterator.DataSetIterator;
import org.nd4j.linalg.dataset.api.preprocessor.DataNormalization;
import org.nd4j.linalg.dataset.api.preprocessor.ImagePreProcessingScaler;
import org.nd4j.linalg.factory.Nd4j;
import org.nd4j.linalg.learning.config.Adam;
import org.nd4j.linalg.lossfunctions.LossFunctions;

import java.awt.BorderLayout;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
//模型训练
public class CNN {

    public static void main(String[] args) throws IOException {
        int height = 28;
        int width = 28;
        int channels = 1;
        int batchSize = 64;
        int epochs = 10;
        double learningRate = 0.001;

        DataSetIterator mnistTrain = new MnistDataSetIterator(batchSize, true, 12345);

        // 构建网络配置
        MultiLayerConfiguration conf = new NeuralNetConfiguration.Builder()
                .seed(12345)
                .optimizationAlgo(OptimizationAlgorithm.STOCHASTIC_GRADIENT_DESCENT)
                .updater(new Adam(learningRate))
                .weightInit(WeightInit.XAVIER)
                .list()
                .setInputType(InputType.convolutionalFlat(height, width, channels))
                .layer(0, new ConvolutionLayer.Builder(5, 5)
                        .nIn(channels)
                        .stride(1, 1)
                        .nOut(32)
                        .activation(Activation.RELU)
                        .build())
                .layer(1, new SubsamplingLayer.Builder(PoolingType.MAX)
                        .kernelSize(2, 2)
                        .stride(2, 2)
                        .build())
                .layer(2, new ConvolutionLayer.Builder(5, 5)
                		.nIn(channels)
                        .stride(1, 1)
                        .nOut(32)
                        .activation(Activation.RELU)
                        .build())
                .layer(3, new SubsamplingLayer.Builder(PoolingType.MAX)
                        .kernelSize(2, 2)
                        .stride(2, 2)
                        .build())
                .layer(4, new DenseLayer.Builder()
                        .activation(Activation.RELU)
                        .nOut(1024)
                        .build())
                .layer(5, new DenseLayer.Builder()
                        .activation(Activation.RELU)
                        .nOut(1024)
                        .build())
                .layer(6, new OutputLayer.Builder()
                        .lossFunction(LossFunctions.LossFunction.MCXENT)  // 或者使用 LossFunctions.LossFunction.MSE，根据任务类型选择
                        .activation(Activation.SOFTMAX)  // 或者使用 Activation.IDENTITY，根据任务类型选择
                        .nIn(1024)
                        .nOut(10)  
                        .build())
                .backpropType(BackpropType.Standard)
                .build();

        // 初始化模型
        MultiLayerNetwork model = new MultiLayerNetwork(conf);
        model.init();

        // 训练模型
        model.setListeners(new ScoreIterationListener(1000)); // 打印训练分数，每1000个batch
        for (int i = 0; i < epochs; i++) {
            while (mnistTrain.hasNext()) {
                DataSet dataSet = mnistTrain.next();
                model.fit(dataSet);
            }
            mnistTrain.reset();
        }

        // 保存模型
        ModelSerializer.writeModel(model, new File("denoising_autoencoder_model.zip"), true);

        // 加载模型
        MultiLayerNetwork loadedModel = ModelSerializer.restoreMultiLayerNetwork(new File("denoising_autoencoder_model.zip"));

        // 然后使用 loadedModel 对图像进行降噪处理
        // 图像路径
        String imagePath = "D:\\Eclipse-workspace\\Image\\src\\main\\java\\test\\test1.jpg";

        // 从文件加载图像
        BufferedImage image = ImageIO.read(new File(imagePath));

        // 将图像转换为 INDArray
        int height1 = image.getHeight();
        int width1 = image.getWidth();
        int channels1 = 1;
        INDArray inputArray = imageToINDArray(image, height1, width1, channels1);

        // 进行数据归一化
        DataNormalization scaler = new ImagePreProcessingScaler(0, 1);
        scaler.transform(inputArray);

        // 在这里使用 loadedModel 对 inputArray 进行降噪处理
        INDArray denoisedArray = loadedModel.output(inputArray);

        // 处理后的图像可以通过将 INDArray 转换回 BufferedImage 进行显示或保存
        BufferedImage denoisedImage = indArrayToImage(denoisedArray, height, width);
     // 显示降噪后的图像
        displayImage(denoisedImage);

        // 保存降噪后的图像
        saveImage(denoisedImage, "denoised_output.jpg");

        // 关闭资源
        image.flush();
        denoisedImage.flush();
    }

    private static INDArray imageToINDArray(BufferedImage image, int height, int width, int channels) {
        INDArray array = Nd4j.create(height, width, channels);
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                int pixelValue = image.getRGB(j, i); // 获取像素值
                array.putScalar(i, j, 0, (pixelValue & 0xFF) / 255.0); // 归一化到 [0, 1]
            }
        }
        return array;
    }
    private static BufferedImage indArrayToImage(INDArray array, int height, int width) {
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                float red = array.getFloat(i, j, 0) * 255.0f;
                float green = array.getFloat(i, j, 1) * 255.0f;
                float blue = array.getFloat(i, j, 2) * 255.0f;

                int rgbValue = (clamp((int) red) << 16) | (clamp((int) green) << 8) | clamp((int) blue);
                image.setRGB(j, i, rgbValue);
            }
        }
        return image;
    }
    private static int clamp(int value) {
        return Math.min(Math.max(value, 0), 255);
    }
    private static void displayImage(BufferedImage image) {
        JFrame frame = new JFrame("Denoised Image");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.getContentPane().setLayout(new BorderLayout());
        frame.getContentPane().add(new JLabel(new ImageIcon(image)));
        frame.pack();
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }

    private static void saveImage(BufferedImage image, String outputPath) throws IOException {
        File outputImage = new File("D:\\Eclipse-workspace\\Image\\src\\main\\java\\test\\");
        ImageIO.write(image, "jpg", outputImage);
        System.out.println("Denoised image saved to: " + outputImage.getAbsolutePath());
    }
}
