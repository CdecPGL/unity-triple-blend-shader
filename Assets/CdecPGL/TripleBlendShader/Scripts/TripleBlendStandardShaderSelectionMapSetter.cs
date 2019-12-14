using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace CdecPGL.TripleBlendShader {
	/// <summary>
	/// 自分及びこのうちでTripleBlendStandardShaderが設定されたマテリアルを持つレンダラーにSelectionMapテクスチャを設定するためのクラス。
	/// </summary>
	public sealed class TripleBlendStandardShaderSelectionMapSetter : MonoBehaviour {
		/// <summary>
		/// シーン内のすべての可能なTripleBlendStandardShaderSelectionMapSetterがアタッチされたオブジェクトにSelectionMapテクスチャを設定する
		/// </summary>
		public static void SetSelectionMapTextureAndAreaToAll(Texture texture, Rect area) {
			var targets = FindObjectsOfType<TripleBlendStandardShaderSelectionMapSetter>();
			foreach (var target in targets) {
				target.SetSelectionMapTexture(texture);
				target.SetSelectionArea(area);
			}
		}

		/// <summary>
		/// SelectionMapテクスチャを設定する
		/// </summary>
		/// <param name="texture"></param>
		public void SetSelectionMapTexture(Texture texture) {
			foreach (var myMaterial in _mySelectionMapRendererMaterialList) {
				myMaterial.SetTexture(_selectionMapPropertyId, texture);
			}
		}

		/// <summary>
		/// SelectionAreaを設定する
		/// </summary>
		/// <param name="area"></param>
		public void SetSelectionArea(Rect area) {
			var areaVector = new Vector4(area.xMin, area.yMin, area.xMax, area.yMax);
			foreach (var myMaterial in _mySelectionMapRendererMaterialList) {
				myMaterial.SetVector(_selectionAreaPropertyId, areaVector);
			}
		}

		private List<Material> _mySelectionMapRendererMaterialList = new List<Material>();

#if UNITY_EDITOR
		private struct PropertyBackup {
			public Texture selectionMap;
			public Vector4 selectionArea;
		}

		private readonly Dictionary<Material, PropertyBackup> _materialPropertyBackup =
			new Dictionary<Material, PropertyBackup>();
#endif

		private static readonly int _selectionMapPropertyId = Shader.PropertyToID("_SelectionMap");
		private static readonly int _selectionAreaPropertyId = Shader.PropertyToID("_SelectionArea");

		private void Awake() {
			// _SelectionMapをプロパティに持っているかどうかで対象を判断する
			// レンダラーのマテリアルを追加
			_mySelectionMapRendererMaterialList = GetComponentsInChildren<Renderer>().Append(GetComponent<Renderer>())
				.Where(r => r).Select(r => r.materials).SelectMany(m => m)
				.Where(m => m.HasProperty(_selectionMapPropertyId)).ToList();

			//　Terrainのマテリアルを追加
			_mySelectionMapRendererMaterialList.AddRange(GetComponentsInChildren<Terrain>()
				.Append(GetComponent<Terrain>())
				.Where(t => t && t.materialTemplate.HasProperty(_selectionMapPropertyId))
				.Select(t => t.materialTemplate).ToList());

#if UNITY_EDITOR
			//Unity2018.3.7f1においてエディター上で実行したときになぜか実行終了時にシェーダーテクスチャの設定が復元ざれないので手動で復元する
			foreach (var myMaterial in _mySelectionMapRendererMaterialList) {
				if (!_materialPropertyBackup.ContainsKey(myMaterial)) {
					_materialPropertyBackup.Add(myMaterial,
						new PropertyBackup {
							selectionMap = myMaterial.GetTexture(_selectionMapPropertyId),
							selectionArea = myMaterial.GetVector(_selectionAreaPropertyId)
						});
				}
			}
#endif
		}

#if UNITY_EDITOR
		private void OnDestroy() {
			foreach (var myMaterial in _mySelectionMapRendererMaterialList) {
				if (!_materialPropertyBackup.ContainsKey(myMaterial)) {
					continue;
				}

				myMaterial.SetTexture(_selectionMapPropertyId, _materialPropertyBackup[myMaterial].selectionMap);
				myMaterial.SetVector(_selectionAreaPropertyId, _materialPropertyBackup[myMaterial].selectionArea);
			}
		}
#endif
	}
}