Image filtering under guidance image, known as guided filtering (GF), has been successfully applied to a variety of applications. Existing GF methods utilize either conventional full window-based framework (FWF) or simple 
uniformly weighted aggregation strategy (UWA); thereby they suffer from edge-blurring. In this paper, based upon gradient guided filtering (GGF), a weighted side-window based gradient guided filtering (WSGGF) is 
proposed to address the aforementioned problem. First, both regression and adaptive regularization terms in GGF are improved upon eight side windows by introducing side window-based framework (SWF). L1 norm is adopted 
to choose the results calculated in side windows. Second, UWA strategy in GGF is replaced by a refined variance-based weighted average (VWA) aggregation. In VWA, the value of each weight is chosen inversely proportional 
to the corresponding estimator. We show that with these improvements our method can well retain the edge sharpness and is robust to visual artifacts. To cut down the time consumption, a fast version of WSGGF (FWSGGF) 
is further proposed by incorporating a simple but effective down-sampling strategy, which is about four times faster while maintaining the superior performance. By comparing with the state-of-the-art (SOTA) methods on 
edge-aware smoothing, detail enhancement, high dynamic range image (HDR) compression, image luminance adjustment, depth map upsampling and single image haze removal, the effectiveness and flexibility of our 
proposed methods are verified.

@article{yuan2024weighted,
  title={Weighted side-window based gradient guided image filtering},
  author={Yuan, Weimin and Meng, Cai and Bai, Xiangzhi},
  journal={Pattern Recognition},
  volume={146},
  pages={110006},
  year={2024},
  publisher={Elsevier}
}
