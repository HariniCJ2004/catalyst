import React, { useState, useMemo, useEffect } from 'react';

type Screen =
  | 'home'
  | 'ingestion'
  | 'extraction'
  | 'assistant'
  | 'portal'
  | 'regulatory'
  | 'comparison'
  | 'generator';

type Product = {
  id: string;
  name: string;
  category: string;
  tds: { version: string; fields: Record<string, string> };
  sds: { version: string; fields: Record<string, string> };
  specs: Record<string, string | number>;
  safety: Record<string, string | number>;
};

type Message = { role: 'user' | 'assistant'; text: string; citations?: string[] };

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>('home');

  const initialProducts: Product[] = useMemo(
    () => [
      {
        id: 'P-001',
        name: 'Catalyst A-12',
        category: 'Catalysts',
        tds: {
          version: 'v3.2',
          fields: {
            'Viscosity (cP)': '150',
            'Specific Gravity': '1.12',
            'Active Content (%)': '92',
            'Shelf Life (months)': '18',
          },
        },
        sds: {
          version: 'v2.4',
          fields: {
            'GHS Classification': 'Skin Irrit. 2; Eye Irrit. 2A',
            'Hazard Statements': 'H315, H319',
            'PPE': 'Gloves, goggles',
            'Storage': 'Cool, dry place',
          },
        },
        specs: {
          Color: 'Pale Yellow',
          'Flash Point (°C)': 78,
          'pH (10% soln)': 6.8,
        },
        safety: {
          'VOC Content (%)': 1.2,
          'Exposure Limit (ppm)': 50,
          'Transport Class': 'Non-hazardous',
        },
      },
      {
        id: 'P-002',
        name: 'Solvent Mix S-9',
        category: 'Solvents',
        tds: {
          version: 'v1.8',
          fields: {
            'Viscosity (cP)': '2.5',
            'Specific Gravity': '0.87',
            'Active Content (%)': 'N/A',
            'Shelf Life (months)': '24',
          },
        },
        sds: {
          version: 'v4.1',
          fields: {
            'GHS Classification': 'Flam. Liq. 2',
            'Hazard Statements': 'H225',
            'PPE': 'Flame-resistant gloves, goggles',
            'Storage': 'Flammable cabinet',
          },
        },
        specs: {
          Color: 'Clear',
          'Flash Point (°C)': 24,
          'pH (10% soln)': 'Neutral',
        },
        safety: {
          'VOC Content (%)': 96,
          'Exposure Limit (ppm)': 200,
          'Transport Class': '3 (Flammable liquids)',
        },
      },
      {
        id: 'P-003',
        name: 'Resin R-55',
        category: 'Resins',
        tds: {
          version: 'v2.0',
          fields: {
            'Viscosity (cP)': '950',
            'Specific Gravity': '1.05',
            'Active Content (%)': '100',
            'Shelf Life (months)': '12',
          },
        },
        sds: {
          version: 'v1.9',
          fields: {
            'GHS Classification': 'Skin Sens. 1',
            'Hazard Statements': 'H317',
            'PPE': 'Gloves, long sleeves',
            'Storage': 'Room temperature',
          },
        },
        specs: {
          Color: 'Amber',
          'Flash Point (°C)': 102,
          'pH (10% soln)': 'N/A',
        },
        safety: {
          'VOC Content (%)': 0.1,
          'Exposure Limit (ppm)': 10,
          'Transport Class': 'Non-hazardous',
        },
      },
    ],
    []
  );

  const [products, setProducts] = useState<Product[]>(initialProducts);

  const [metrics, setMetrics] = useState({
    documentsIngested: 324,
    ingestionBacklog: 12,
    ingestionSuccessRate: 97,
    extractionRuns: 189,
    extractionSuccessRate: 94,
    assistantAnswers: 512,
    portalDownloads: 276,
    complianceScore: 92,
    riskIndex: 18,
    comparisonsRun: 74,
    contentGenerated: 43,
  });

  const [queue, setQueue] = useState<{ id: string; name: string; type: string; status: 'Queued' | 'Classified' | 'Extracted' | 'Validated' | 'Stored' }[]>([
    { id: 'D-1101', name: 'SDS_CatalystA12.pdf', type: 'SDS', status: 'Queued' },
    { id: 'D-1102', name: 'TDS_SolventS9.pdf', type: 'TDS', status: 'Classified' },
    { id: 'D-1103', name: 'Spec_Sheet_R55.docx', type: 'Spec', status: 'Extracted' },
  ]);

  const knowledgeBase = useMemo(
    () => [
      { id: 'KB-001', title: 'TDS Catalyst A-12 v3.2', score: 0.91, snippet: 'Viscosity 150 cP; Active content 92%' },
      { id: 'KB-002', title: 'SDS Catalyst A-12 v2.4', score: 0.88, snippet: 'Irritant classification, PPE required' },
      { id: 'KB-003', title: 'SDS Solvent S-9 v4.1', score: 0.86, snippet: 'Highly flammable liquid H225' },
      { id: 'KB-004', title: 'TDS Resin R-55 v2.0', score: 0.83, snippet: 'Viscosity 950 cP; 100% solids' },
    ],
    []
  );

  const regulations = useMemo(
    () => [
      { id: 'REG-001', name: 'EU REACH Annex XVII Update', status: 'Monitoring', impact: 'Medium', dueInDays: 45 },
      { id: 'REG-002', name: 'OSHA Hazard Communication 2024', status: 'Compliant', impact: 'Low', dueInDays: 180 },
      { id: 'REG-003', name: 'EPA TSCA PFAS Reporting', status: 'Action Required', impact: 'High', dueInDays: 30 },
      { id: 'REG-004', name: 'GHS Rev.9 Alignment', status: 'Monitoring', impact: 'Medium', dueInDays: 90 },
    ],
    []
  );

  const navItems: { key: Screen; label: string; icon: string }[] = [
    { key: 'home', label: 'Home', icon: '🏠' },
    { key: 'ingestion', label: 'Automate Ingestion', icon: '⚙️' },
    { key: 'extraction', label: 'Data Extraction', icon: '🧪' },
    { key: 'assistant', label: 'Agentic RAG Assistant', icon: '🤖' },
    { key: 'portal', label: 'Customer Product Portal', icon: '📦' },
    { key: 'regulatory', label: 'Regulatory Dashboard', icon: '🛡️' },
    { key: 'comparison', label: 'Smart Comparison', icon: '🆚' },
    { key: 'generator', label: 'AI Content Generator', icon: '📝' },
  ];

  const heightClass = (value: number, max: number) => {
    const ratios = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
    const classes = ['h-2', 'h-4', 'h-6', 'h-8', 'h-10', 'h-12', 'h-16', 'h-20', 'h-24', 'h-28', 'h-32'];
    const pct = Math.min(100, Math.max(0, Math.round((value / max) * 100)));
    let idx = 0;
    for (let i = 0; i < ratios.length; i++) {
      if (pct >= ratios[i]) idx = i;
    }
    return classes[idx];
  };

  const distributionBar = (parts: { label: string; value: number; color: string }[]) => {
    const sum = parts.reduce((a, b) => a + b.value, 0) || 1;
    const widths = parts.map((p) => Math.round((p.value / sum) * 100));
    const colors: Record<string, string> = {
      teal: 'bg-slate-500',
      sky: 'bg-slate-400',
      amber: 'bg-slate-300',
      indigo: 'bg-slate-500',
      lime: 'bg-slate-400',
      rose: 'bg-slate-500',
      emerald: 'bg-slate-400',
      orange: 'bg-slate-400',
      violet: 'bg-slate-500',
    };
    return (
      <div className="w-full h-3 rounded-md overflow-hidden bg-slate-900/40 ring-1 ring-white/10 flex">
        {parts.map((p, idx) => (
          <div
            key={p.label + idx}
            className={`${colors[p.color] || 'bg-slate-500'} h-full`}
            style={{ width: `${widths[idx]}%` } as React.CSSProperties}
          />
        ))}
      </div>
    );
  };

  const HomeDashboard = () => {
    const lineData = [42, 48, 56, 60, 58, 64, 72, 76, 80, 88, 96, 100];
    const maxLine = Math.max(...lineData);
    const dist = [
      { label: 'SDS', value: 142, color: 'teal' },
      { label: 'TDS', value: 106, color: 'sky' },
      { label: 'Spec', value: 76, color: 'amber' },
    ];
    return (
      <div className="p-6 space-y-6">
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
          <MetricCard title="Documents Ingested" value={metrics.documentsIngested.toString()} trend="+12% MoM" />
          <MetricCard title="Extraction Success" value={`${metrics.extractionSuccessRate}%`} trend="+3 pts QoQ" />
          <MetricCard title="Assistant Answers" value={metrics.assistantAnswers.toString()} trend="+18 this week" />
          <MetricCard title="Compliance Score" value={`${metrics.complianceScore}%`} trend="Stable" />
        </div>
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
            <div className="flex items-center justify-between mb-3">
              <h3 className="text-slate-100 font-semibold">Document Throughput (12w)</h3>
              <span className="text-xs text-slate-400">Ingestion</span>
            </div>
            <div className="flex items-end gap-2 h-40">
              {lineData.map((v, i) => (
                <div key={i} className={`flex-1 rounded-md bg-slate-400/70 ${heightClass(v, maxLine)}`} />
              ))}
            </div>
            <div className="mt-3 text-xs text-slate-400">Steady growth in weekly ingestion volume</div>
          </div>
          <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
            <div className="flex items-center justify-between mb-3">
              <h3 className="text-slate-100 font-semibold">File Type Distribution</h3>
              <span className="text-xs text-slate-400">YTD</span>
            </div>
            {distributionBar(dist)}
            <div className="mt-4 grid grid-cols-3 gap-2 text-xs">
              {dist.map((d) => (
                <div key={d.label} className="flex items-center gap-2">
                  <span className={`inline-block w-2 h-2 rounded-full ${d.color === 'teal' ? 'bg-slate-500' : d.color === 'sky' ? 'bg-slate-400' : 'bg-slate-300'}`} />
                  <span className="text-slate-300">{d.label}</span>
                  <span className="text-slate-400 ml-auto">{d.value}</span>
                </div>
              ))}
            </div>
          </div>
          <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
            <div className="flex items-center justify-between mb-3">
              <h3 className="text-slate-100 font-semibold">Portfolio Risk Heatmap</h3>
              <span className="text-xs text-slate-400">Regulatory</span>
            </div>
            <div className="grid grid-cols-6 gap-2">
              {[...Array(18)].map((_, i) => {
                const val = (i * 7 + 13) % 100;
                const color =
                  val > 75 ? 'bg-slate-300/70' : val > 50 ? 'bg-slate-400/70' : val > 25 ? 'bg-slate-500/60' : 'bg-slate-600/60';
                return <div key={i} className={`h-6 rounded ${color}`} />;
              })}
            </div>
            <div className="mt-3 text-xs text-slate-400">Hot spots indicate higher regulatory attention</div>
          </div>
        </div>
        <div className="grid grid-cols-1 xl:grid-cols-2 gap-6">
          <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
            <div className="flex items-center justify-between mb-3">
              <h3 className="text-slate-100 font-semibold">At-a-Glance</h3>
            </div>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              <TinyStat label="Backlog" value={metrics.ingestionBacklog.toString()} color="bg-slate-400/80" />
              <TinyStat label="Comparisons" value={metrics.comparisonsRun.toString()} color="bg-slate-400/80" />
              <TinyStat label="Portal Downloads" value={metrics.portalDownloads.toString()} color="bg-slate-400/80" />
              <TinyStat label="Content Generated" value={metrics.contentGenerated.toString()} color="bg-slate-400/80" />
            </div>
          </div>
          <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
            <div className="flex items-center justify-between mb-3">
              <h3 className="text-slate-100 font-semibold">Quick Links</h3>
            </div>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
              {navItems
                .filter((n) => n.key !== 'home')
                .map((n) => (
                  <button
                    key={n.key}
                    onClick={() => setCurrentScreen(n.key)}
                    className="flex items-center justify-between gap-2 bg-slate-950/30 ring-1 ring-white/10 hover:ring-white/20 hover:bg-white/5 transition rounded-lg px-4 py-3"
                  >
                    <span className="text-slate-200">{n.icon} {n.label}</span>
                    <span className="text-slate-300 text-xs">Open →</span>
                  </button>
                ))}
            </div>
          </div>
        </div>
      </div>
    );
  };

  const AutomateIngestionPage = () => {
    const [uploadName, setUploadName] = useState('');
    const [uploadType, setUploadType] = useState<'SDS' | 'TDS' | 'Spec'>('SDS');
    const [pipelineStage, setPipelineStage] = useState(['Upload', 'Classify', 'Extract', 'Validate', 'Store']);

    const typeDistribution = useMemo(() => {
      const counts = { SDS: 0, TDS: 0, Spec: 0 };
      queue.forEach((d) => (counts[d.type as 'SDS' | 'TDS' | 'Spec'] += 1));
      return [
        { label: 'SDS', value: counts.SDS, color: 'teal' },
        { label: 'TDS', value: counts.TDS, color: 'sky' },
        { label: 'Spec', value: counts.Spec, color: 'amber' },
      ];
    }, [queue]);

    const enqueueDoc = () => {
      if (!uploadName.trim()) return;
      const newDoc = {
        id: 'D-' + Math.floor(Math.random() * 9000 + 1000),
        name: uploadName,
        type: uploadType,
        status: 'Queued' as const,
      };
      setQueue([newDoc, ...queue]);
      setUploadName('');
      setMetrics((m) => ({ ...m, documentsIngested: m.documentsIngested + 1, ingestionBacklog: m.ingestionBacklog + 1 }));
    };

    const advanceQueue = () => {
      setQueue((prev) =>
        prev.map((d) => {
          const next = nextStatus(d.status);
          return { ...d, status: next };
        })
      );
      setMetrics((m) => ({ ...m, ingestionSuccessRate: Math.min(99, m.ingestionSuccessRate + 0.2 as any) }));
    };

    return (
      <div className="p-6 space-y-6">
        <SectionHeader title="Automate Ingestion" subtitle="Scalable pipeline for semi-structured documents across SDS, TDS, and specification sheets." />
        <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
          <div className="xl:col-span-2 space-y-6">
            <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-slate-100 font-semibold">Upload & Queue</h3>
              </div>
              <div className="flex flex-col md:flex-row gap-3">
                <input
                  value={uploadName}
                  onChange={(e) => setUploadName(e.target.value)}
                  placeholder="e.g., SDS_NewProduct_v1.pdf"
                  className="w-full md:flex-1 bg-slate-950/30 rounded-lg px-3 py-2 text-slate-200 placeholder:text-slate-500 ring-1 ring-white/10 focus:ring-white/20 outline-none"
                />
                <select
                  value={uploadType}
                  onChange={(e) => setUploadType(e.target.value as 'SDS' | 'TDS' | 'Spec')}
                  className="bg-slate-950/30 rounded-lg px-3 py-2 text-slate-200 ring-1 ring-white/10 focus:ring-white/20 outline-none"
                >
                  <option value="SDS">SDS</option>
                  <option value="TDS">TDS</option>
                  <option value="Spec">Spec</option>
                </select>
                <button onClick={enqueueDoc} className="px-4 py-2 rounded-lg bg-slate-100 hover:bg-white text-slate-900 font-medium">
                  Enqueue
                </button>
              </div>
              <div className="mt-5">
                <div className="flex items-center justify-between mb-2">
                  <span className="text-slate-300 text-sm">Pipeline Stages</span>
                  <button onClick={advanceQueue} className="text-slate-200/90 text-sm hover:underline">
                    Advance All →
                  </button>
                </div>
                <div className="flex items-center gap-2">
                  {pipelineStage.map((s, i) => (
                    <div key={s} className="flex items-center gap-2">
                      <div className="px-3 py-1 rounded-full bg-white/5 ring-1 ring-white/10 text-xs text-slate-200">{s}</div>
                      {i < pipelineStage.length - 1 && <div className="w-6 h-0.5 bg-slate-600" />}
                    </div>
                  ))}
                </div>
              </div>
            </div>
            <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <h3 className="text-slate-100 font-semibold mb-3">Active Queue</h3>
              <div className="grid grid-cols-6 text-xs text-slate-400 px-2 py-2">
                <div className="col-span-2">Document</div>
                <div>Type</div>
                <div>Status</div>
                <div className="col-span-2 text-right">Actions</div>
              </div>
              <div className="divide-y divide-white/10">
                {queue.map((d) => (
                  <div key={d.id} className="grid grid-cols-6 items-center px-2 py-3">
                    <div className="col-span-2 text-slate-200">{d.name}</div>
                    <div className="text-slate-300">{d.type}</div>
                    <div className="flex items-center gap-2">
                      <span className={`inline-block w-2 h-2 rounded-full ${statusDot(d.status)}`} />
                      <span className="text-slate-300">{d.status}</span>
                    </div>
                    <div className="col-span-2 flex items-center justify-end gap-2">
                      <button
                        onClick={() => manualAdvance(d.id)}
                        className="px-3 py-1 text-xs rounded bg-white/10 hover:bg-white/20 text-slate-100"
                      >
                        Advance
                      </button>
                      <button
                        onClick={() => removeDoc(d.id)}
                        className="px-3 py-1 text-xs rounded bg-white/10 hover:bg-white/20 text-slate-100"
                      >
                        Remove
                      </button>
                    </div>
                  </div>
                ))}
                {queue.length === 0 && <div className="text-slate-400 text-sm p-4">Queue is empty. Upload new documents to process.</div>}
              </div>
            </div>
          </div>
          <div className="space-y-6">
            <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <h3 className="text-slate-100 font-semibold mb-3">Type Distribution</h3>
              {distributionBar(typeDistribution)}
              <div className="mt-3 grid grid-cols-3 gap-2 text-xs">
                {typeDistribution.map((d) => (
                  <div key={d.label} className="flex items-center gap-2">
                    <span className={`inline-block w-2 h-2 rounded-full ${d.color === 'teal' ? 'bg-slate-500' : d.color === 'sky' ? 'bg-slate-400' : 'bg-slate-300'}`} />
                    <span className="text-slate-300">{d.label}</span>
                    <span className="text-slate-400 ml-auto">{d.value}</span>
                  </div>
                ))}
              </div>
            </div>
            <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <h3 className="text-slate-100 font-semibold mb-3">Pipeline Health</h3>
              <div className="space-y-2">
                <HealthRow label="Success Rate" value={`${metrics.ingestionSuccessRate}%`} barClass="bg-slate-200/80" pct={metrics.ingestionSuccessRate} />
                <HealthRow label="Backlog" value={`${metrics.ingestionBacklog} docs`} barClass="bg-slate-200/60" pct={Math.min(100, (metrics.ingestionBacklog / 50) * 100)} />
                <HealthRow label="Latency (avg)" value="1.8 min" barClass="bg-slate-200/70" pct={65} />
              </div>
            </div>
          </div>
        </div>
      </div>
    );

    function statusDot(s: typeof queue[number]['status']) {
      if (s === 'Queued') return 'bg-slate-500';
      if (s === 'Classified') return 'bg-slate-400';
      if (s === 'Extracted') return 'bg-slate-300';
      if (s === 'Validated') return 'bg-slate-200';
      return 'bg-slate-200';
    }

    function nextStatus(s: typeof queue[number]['status']): typeof queue[number]['status'] {
      const order: typeof queue[number]['status'][] = ['Queued', 'Classified', 'Extracted', 'Validated', 'Stored'];
      const idx = order.indexOf(s);
      return order[Math.min(order.length - 1, idx + 1)];
    }

    function manualAdvance(id: string) {
      setQueue((prev) =>
        prev.map((d) => {
          if (d.id !== id) return d;
          const next = nextStatus(d.status);
          return { ...d, status: next };
        })
      );
    }

    function removeDoc(id: string) {
      setQueue((prev) => prev.filter((d) => d.id !== id));
      setMetrics((m) => ({ ...m, ingestionBacklog: Math.max(0, m.ingestionBacklog - 1) }));
    }
  };

  const DataExtractionPage = () => {
    const [files, setFiles] = useState<{ name: string; type: 'SDS' | 'TDS' | 'Spec' }[]>([
      { name: 'SDS_CatalystA12.pdf', type: 'SDS' },
      { name: 'TDS_ResinR55.pdf', type: 'TDS' },
    ]);
    const [extracted, setExtracted] = useState<{ file: string; fields: Record<string, string> }[]>([
      { file: 'SDS_CatalystA12.pdf', fields: { 'GHS Classification': 'Irritant', 'PPE': 'Gloves, goggles' } },
    ]);
    const [newFileName, setNewFileName] = useState('');
    const [newFileType, setNewFileType] = useState<'SDS' | 'TDS' | 'Spec'>('SDS');

    const runExtraction = () => {
      if (files.length === 0) return;
      const target = files[0];
      const fields =
        target.type === 'SDS'
          ? { 'Hazard Statements': 'H315, H319', 'PPE': 'Gloves, goggles', 'Storage': 'Cool, dry place' }
          : target.type === 'TDS'
          ? { 'Viscosity (cP)': '140', 'Specific Gravity': '1.10', 'Shelf Life (months)': '18' }
          : { 'Particle Size (μm)': '25-40', 'Purity (%)': '99.1', 'Moisture (%)': '0.2' };
      setExtracted((prev) => [{ file: target.name, fields }, ...prev]);
      setFiles((prev) => prev.slice(1));
      setMetrics((m) => ({ ...m, extractionRuns: m.extractionRuns + 1 }));
    };

    const addFile = () => {
      if (!newFileName.trim()) return;
      setFiles([{ name: newFileName, type: newFileType }, ...files]);
      setNewFileName('');
    };

    return (
      <div className="p-6 space-y-6">
        <SectionHeader title="Data Extraction" subtitle="Extract technical specifications and safety guidelines from uploaded documents." />
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 space-y-6">
            <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <h3 className="text-slate-100 font-semibold mb-3">Upload Queue</h3>
              <div className="flex flex-col md:flex-row gap-3 mb-4">
                <input
                  value={newFileName}
                  onChange={(e) => setNewFileName(e.target.value)}
                  placeholder="e.g., SDS_NewProduct_v2.pdf"
                  className="w-full md:flex-1 bg-slate-950/30 rounded-lg px-3 py-2 text-slate-200 placeholder:text-slate-500 ring-1 ring-white/10 focus:ring-white/20 outline-none"
                />
                <select
                  value={newFileType}
                  onChange={(e) => setNewFileType(e.target.value as any)}
                  className="bg-slate-950/30 rounded-lg px-3 py-2 text-slate-200 ring-1 ring-white/10 focus:ring-white/20 outline-none"
                >
                  <option value="SDS">SDS</option>
                  <option value="TDS">TDS</option>
                  <option value="Spec">Spec</option>
                </select>
                <button onClick={addFile} className="px-4 py-2 rounded-lg bg-white/10 hover:bg-white/20 text-slate-100 font-medium">
                  Add
                </button>
                <button onClick={runExtraction} className="px-4 py-2 rounded-lg bg-slate-100 hover:bg-white text-slate-900 font-medium">
                  Extract Next
                </button>
              </div>
              <div className="space-y-2">
                {files.map((f, i) => (
                  <div key={f.name + i} className="flex items-center justify-between bg-slate-950/30 ring-1 ring-white/10 rounded-lg px-3 py-2">
                    <div className="flex items-center gap-3">
                      <span className={`inline-block w-2 h-2 rounded-full ${f.type === 'SDS' ? 'bg-slate-400' : f.type === 'TDS' ? 'bg-slate-300' : 'bg-slate-200'}`} />
                      <span className="text-slate-200">{f.name}</span>
                    </div>
                    <span className="text-slate-400 text-xs">{f.type}</span>
                  </div>
                ))}
                {files.length === 0 && <div className="text-slate-400 text-sm">No files in queue. Add more to extract.</div>}
              </div>
            </div>
            <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <h3 className="text-slate-100 font-semibold mb-3">Extracted Fields</h3>
              <div className="space-y-4">
                {extracted.map((e, idx) => (
                  <div key={e.file + idx} className="bg-slate-950/30 ring-1 ring-white/10 rounded-lg p-4">
                    <div className="text-slate-300 text-sm mb-2">{e.file}</div>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                      {Object.entries(e.fields).map(([k, v]) => (
                        <div key={k} className="bg-white/5 ring-1 ring-white/10 rounded-lg px-3 py-2">
                          <div className="text-xs text-slate-400">{k}</div>
                          <div className="text-slate-200">{v}</div>
                        </div>
                      ))}
                    </div>
                  </div>
                ))}
                {extracted.length === 0 && <div className="text-slate-400 text-sm">No extractions yet. Run extraction to see results.</div>}
              </div>
            </div>
          </div>
          <div className="space-y-6">
            <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <h3 className="text-slate-100 font-semibold mb-3">Extraction Performance</h3>
              <div className="space-y-2">
                <HealthRow label="Success Rate" value={`${metrics.extractionSuccessRate}%`} barClass="bg-slate-200/80" pct={metrics.extractionSuccessRate} />
                <HealthRow label="Runs" value={metrics.extractionRuns.toString()} barClass="bg-slate-200/70" pct={Math.min(100, (metrics.extractionRuns / 300) * 100)} />
                <HealthRow label="Fields per doc (avg)" value="8.4" barClass="bg-slate-200/60" pct={84} />
              </div>
              <div className="mt-4 text-xs text-slate-400">Ground truth aligned from validated SDS/TDS documents.</div>
            </div>
          </div>
        </div>
      </div>
    );
  };

  const AgenticRAGPage = () => {
    const [messages, setMessages] = useState<Message[]>([
      { role: 'assistant', text: 'Ask about product specifications, safety measures, or handling guidance. I will cite validated sources.' },
    ]);
    const [input, setInput] = useState('');
    const [showSources, setShowSources] = useState(true);

    const send = () => {
      if (!input.trim()) return;
      const userMsg: Message = { role: 'user', text: input.trim() };
      const hits = retrieve(input);
      const answer = buildAnswer(input, hits);
      const asstMsg: Message = { role: 'assistant', text: answer, citations: hits.map((h) => h.title) };
      setMessages((prev) => [...prev, userMsg, asstMsg]);
      setInput('');
      setMetrics((m) => ({ ...m, assistantAnswers: m.assistantAnswers + 1 }));
    };

    return (
      <div className="p-6 space-y-6">
        <SectionHeader title="Agentic RAG Assistant" subtitle="Reliable, traceable insights grounded in validated TDS, SDS, and enterprise content." />
        <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
          <div className="xl:col-span-2 bg-slate-950/40 ring-1 ring-white/10 rounded-xl flex flex-col h-[70vh] shadow-sm">
            <div className="flex items-center justify-between p-4 border-b border-white/10">
              <div className="text-slate-200 font-semibold">Chat</div>
              <label className="flex items-center gap-2 text-xs text-slate-300">
                <input type="checkbox" checked={showSources} onChange={(e) => setShowSources(e.target.checked)} className="accent-slate-200" />
                Show sources
              </label>
            </div>
            <div className="flex-1 overflow-y-auto p-4 space-y-4">
              {messages.map((m, i) => (
                <div key={i} className={`max-w-3xl ${m.role === 'user' ? 'ml-auto' : ''}`}>
                  <div className={`px-4 py-3 rounded-lg ${m.role === 'user' ? 'bg-white/10 ring-1 ring-white/20 text-slate-100' : 'bg-slate-950/30 ring-1 ring-white/10 text-slate-100'}`}>
                    <div className="whitespace-pre-wrap">{m.text}</div>
                    {m.role === 'assistant' && showSources && m.citations && (
                      <div className="mt-3 text-xs text-slate-400">
                        Sources: {m.citations.map((c, idx) => <span key={idx} className="mr-2">[{idx + 1}] {c}</span>)}
                      </div>
                    )}
                  </div>
                </div>
              ))}
            </div>
            <div className="p-4 border-t border-white/10">
              <div className="flex gap-3">
                <input
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  onKeyDown={(e) => e.key === 'Enter' && send()}
                  placeholder="Ask about viscosity, hazard class, PPE, or storage..."
                  className="flex-1 bg-slate-950/30 rounded-lg px-4 py-2 text-slate-200 placeholder:text-slate-500 ring-1 ring-white/10 focus:ring-white/20 outline-none"
                />
                <button onClick={send} className="px-4 py-2 rounded-lg bg-slate-100 hover:bg-white text-slate-900 font-medium">
                  Ask
                </button>
              </div>
            </div>
          </div>
          <div className="space-y-6">
            <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <h3 className="text-slate-100 font-semibold mb-3">Recent Sources</h3>
              <div className="space-y-3">
                {knowledgeBase.map((k) => (
                  <div key={k.id} className="bg-slate-950/30 ring-1 ring-white/10 rounded-lg p-3">
                    <div className="flex items-center justify-between">
                      <span className="text-slate-200 text-sm">{k.title}</span>
                      <span className="text-xs text-slate-300">{Math.round(k.score * 100)}%</span>
                    </div>
                    <div className="text-xs text-slate-400 mt-1">{k.snippet}</div>
                  </div>
                ))}
              </div>
              <div className="mt-4 text-xs text-slate-400">All answers are grounded in validated documents with transparent citations.</div>
            </div>
          </div>
        </div>
      </div>
    );

    function retrieve(q: string) {
      const terms = q.toLowerCase().split(/\s+/);
      return knowledgeBase
        .map((k) => ({
          ...k,
          score: k.score + (terms.some((t) => k.title.toLowerCase().includes(t) || k.snippet.toLowerCase().includes(t)) ? 0.05 : 0),
        }))
        .sort((a, b) => b.score - a.score)
        .slice(0, 3);
    }

    function buildAnswer(q: string, hits: { title: string; snippet: string }[]) {
      if (q.toLowerCase().includes('viscosity')) {
        return `Based on [1] and [2], viscosity for Catalyst A-12 is 150 cP per TDS v3.2. Ensure handling at ambient conditions and confirm with latest TDS before use.`;
      }
      if (q.toLowerCase().includes('flamm')) {
        return `Per [3], Solvent S-9 is classified as Flammable Liquid (Category 2). Store in a flammable cabinet and follow H225 precautions including ignition control.`;
      }
      return `I found supporting details in ${hits.map((h, i) => `[${i + 1}]`).join(', ')}. Please refer to cited documents for authoritative values and handling guidance.`;
    }
  };

  const ProductPortalPage = () => {
    const [query, setQuery] = useState('');
    const [category, setCategory] = useState('All');
    const cats = ['All', ...Array.from(new Set(products.map((p) => p.category)))];
    const filtered = products.filter((p) => (category === 'All' || p.category === category) && p.name.toLowerCase().includes(query.toLowerCase()));

    const download = (id: string, type: 'TDS' | 'SDS') => {
      setMetrics((m) => ({ ...m, portalDownloads: m.portalDownloads + 1 }));
    };

    return (
      <div className="p-6 space-y-6">
        <SectionHeader title="Customer Product Portal" subtitle="Browse products and securely access technical specifications and safety documents." />
        <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-4 shadow-sm">
          <div className="flex flex-col md:flex-row gap-3">
            <input
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Search products..."
              className="flex-1 bg-slate-950/30 rounded-lg px-3 py-2 text-slate-200 placeholder:text-slate-500 ring-1 ring-white/10 focus:ring-white/20 outline-none"
            />
            <select
              value={category}
              onChange={(e) => setCategory(e.target.value)}
              className="bg-slate-950/30 rounded-lg px-3 py-2 text-slate-200 ring-1 ring-white/10 focus:ring-white/20 outline-none"
            >
              {cats.map((c) => (
                <option key={c} value={c}>
                  {c}
                </option>
              ))}
            </select>
          </div>
        </div>
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {filtered.map((p) => (
            <div key={p.id} className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <div className="flex items-center justify-between mb-2">
                <div className="text-slate-100 font-semibold">{p.name}</div>
                <div className="px-2 py-0.5 rounded bg-white/10 text-xs text-slate-300">{p.category}</div>
              </div>
              <div className="text-xs text-slate-400 mb-3">TDS {p.tds.version} • SDS {p.sds.version}</div>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <div className="bg-slate-950/30 ring-1 ring-white/10 rounded-lg p-3">
                  <div className="text-slate-300 mb-1">Key Specs</div>
                  <ul className="text-xs text-slate-400 space-y-1">
                    {Object.entries(p.specs).slice(0, 3).map(([k, v]) => (
                      <li key={k}>
                        <span className="text-slate-500">{k}:</span> {String(v)}
                      </li>
                    ))}
                  </ul>
                </div>
                <div className="bg-slate-950/30 ring-1 ring-white/10 rounded-lg p-3">
                  <div className="text-slate-300 mb-1">Safety</div>
                  <ul className="text-xs text-slate-400 space-y-1">
                    {Object.entries(p.safety).slice(0, 3).map(([k, v]) => (
                      <li key={k}>
                        <span className="text-slate-500">{k}:</span> {String(v)}
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
              <div className="mt-4 flex items-center gap-2">
                <button onClick={() => download(p.id, 'TDS')} className="px-3 py-2 rounded bg-slate-100 hover:bg-white text-slate-900 text-sm font-medium">
                  Download TDS
                </button>
                <button onClick={() => download(p.id, 'SDS')} className="px-3 py-2 rounded bg-white/10 hover:bg-white/20 text-slate-100 text-sm font-medium">
                  Download SDS
                </button>
                <button onClick={() => setCurrentScreen('comparison')} className="px-3 py-2 rounded bg-white/10 hover:bg-white/20 text-slate-200 text-sm ml-auto">
                  Compare →
                </button>
              </div>
            </div>
          ))}
          {filtered.length === 0 && <div className="text-slate-400 text-sm">No products match your filters.</div>}
        </div>
      </div>
    );
  };

  const RegulatoryDashboardPage = () => {
    const heatValues = useMemo(() => [...Array(24)].map((_, i) => (i * 11 + 23) % 100), []);
    const scoreColor = 'text-slate-100';

    return (
      <div className="p-6 space-y-6">
        <SectionHeader title="AI-Powered Regulatory Dashboard" subtitle="Real-time analysis, compliance status, and portfolio risk across markets." />
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 space-y-6">
            <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <div className="flex items-center justify-between mb-3">
                <h3 className="text-slate-100 font-semibold">Risk Heatmap</h3>
                <div className="text-xs text-slate-400">Higher intensity indicates elevated risk</div>
              </div>
              <div className="grid grid-cols-8 gap-2">
                {heatValues.map((v, i) => {
                  const color = v > 80 ? 'bg-slate-200/80' : v > 60 ? 'bg-slate-300/70' : v > 40 ? 'bg-slate-400/70' : v > 20 ? 'bg-slate-500/60' : 'bg-slate-600/60';
                  return <div key={i} className={`h-8 rounded ${color}`} />;
                })}
              </div>
            </div>
            <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <h3 className="text-slate-100 font-semibold mb-3">Regulatory Timeline</h3>
              <div className="space-y-3">
                {regulations.map((r) => (
                  <div key={r.id} className="flex items-center justify-between bg-slate-950/30 ring-1 ring-white/10 rounded-lg p-3">
                    <div>
                      <div className="text-slate-200">{r.name}</div>
                      <div className="text-xs text-slate-400">Due in {r.dueInDays} days</div>
                    </div>
                    <div className="flex items-center gap-2">
                      <span className="text-xs px-2 py-1 rounded bg-white/10 text-slate-100 ring-1 ring-white/10">
                        {r.status}
                      </span>
                      <span className="text-xs px-2 py-1 rounded bg-white/10 text-slate-100 ring-1 ring-white/10">
                        {r.impact} Impact
                      </span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
          <div className="space-y-6">
            <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <h3 className="text-slate-100 font-semibold mb-1">Compliance Score</h3>
              <div className={`text-5xl font-bold ${scoreColor}`}>{metrics.complianceScore}%</div>
              <div className="text-xs text-slate-400 mt-1">Weighted across regions and product lines</div>
              <div className="mt-4 space-y-2">
                <HealthRow label="EU" value="94%" barClass="bg-slate-200/80" pct={94} />
                <HealthRow label="US" value="91%" barClass="bg-slate-200/80" pct={91} />
                <HealthRow label="APAC" value="89%" barClass="bg-slate-200/60" pct={89} />
              </div>
            </div>
            <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
              <h3 className="text-slate-100 font-semibold mb-3">Open Actions</h3>
              <div className="space-y-2">
                <ActionRow label="Update PFAS disclosure (S-9)" status="High" />
                <ActionRow label="GHS label review (A-12)" status="Medium" />
                <ActionRow label="Safety training refresh (R-55)" status="Low" />
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  };

  const ComparisonPage = () => {
    const [left, setLeft] = useState(products[0]?.id || '');
    const [right, setRight] = useState(products[1]?.id || '');
    const leftP = products.find((p) => p.id === left);
    const rightP = products.find((p) => p.id === right);

    useEffect(() => {
      if (!left && products[0]) setLeft(products[0].id);
      if (!right && products[1]) setRight(products[1].id);
    }, [products, left, right]);

    const bothFields = useMemo(() => {
      const tdsKeys = new Set<string>([...(Object.keys(leftP?.tds.fields || {})), ...(Object.keys(rightP?.tds.fields || {}))]);
      const sdsKeys = new Set<string>([...(Object.keys(leftP?.sds.fields || {})), ...(Object.keys(rightP?.sds.fields || {}))]);
      return { tds: Array.from(tdsKeys), sds: Array.from(sdsKeys) };
    }, [leftP, rightP]);

    const runCompare = () => {
      setMetrics((m) => ({ ...m, comparisonsRun: m.comparisonsRun + 1 }));
    };

    return (
      <div className="p-6 space-y-6">
        <SectionHeader title="Smart Product Comparison" subtitle="Side-by-side evaluation of TDS & SDS powered by AI." />
        <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-4 shadow-sm">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
            <select value={left} onChange={(e) => setLeft(e.target.value)} className="bg-slate-950/30 rounded-lg px-3 py-2 text-slate-200 ring-1 ring-white/10 focus:ring-white/20 outline-none">
              {products.map((p) => (
                <option key={p.id} value={p.id}>
                  {p.name}
                </option>
              ))}
            </select>
            <div className="flex items-center justify-center text-slate-400">vs</div>
            <select value={right} onChange={(e) => setRight(e.target.value)} className="bg-slate-950/30 rounded-lg px-3 py-2 text-slate-200 ring-1 ring-white/10 focus:ring-white/20 outline-none">
              {products.map((p) => (
                <option key={p.id} value={p.id}>
                  {p.name}
                </option>
              ))}
            </select>
          </div>
          <div className="mt-4 flex justify-end">
            <button onClick={runCompare} className="px-4 py-2 rounded-lg bg-slate-100 hover:bg-white text-slate-900 font-medium">
              Run Comparison
            </button>
          </div>
        </div>
        <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
          <div className="space-y-6">
            <ComparisonPanel title="TDS" subtitle="Technical Data Sheet" left={leftP?.tds.fields || {}} right={rightP?.tds.fields || {}} />
            <ComparisonPanel title="SDS" subtitle="Safety Data Sheet" left={leftP?.sds.fields || {}} right={rightP?.sds.fields || {}} />
          </div>
          <div className="xl:col-span-2 bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
            <h3 className="text-slate-100 font-semibold mb-2">AI Insights</h3>
            <div className="text-slate-300">
              {leftP && rightP ? (
                <ul className="list-disc pl-6 space-y-2">
                  <li>
                    {leftP.name} shows {leftP.tds.fields['Viscosity (cP)'] || 'N/A'} cP vs {rightP.name} {rightP.tds.fields['Viscosity (cP)'] || 'N/A'} cP. Select the product that aligns with your application flow requirements.
                  </li>
                  <li>
                    Flammability considerations: {leftP.name} transport class {leftP.safety['Transport Class'] || 'N/A'} vs {rightP.name} {rightP.safety['Transport Class'] || 'N/A'}. Ensure storage and handling meet local regulations.
                  </li>
                  <li>Review PPE guidance differences to align with site safety protocols and training.</li>
                </ul>
              ) : (
                <div className="text-slate-400 text-sm">Select two products to see insights.</div>
              )}
            </div>
          </div>
        </div>
      </div>
    );
  };

  const ContentGeneratorPage = () => {
    const [selected, setSelected] = useState(products[0]?.id || '');
    const [type, setType] = useState<'Fact Sheet' | 'Marketing Summary' | 'Comparison Brief'>('Fact Sheet');
    const [output, setOutput] = useState('');

    useEffect(() => {
      if (!selected && products[0]) setSelected(products[0].id);
    }, [products, selected]);

    const generate = () => {
      const p = products.find((x) => x.id === selected);
      if (!p) return;
      let text = '';
      if (type === 'Fact Sheet') {
        text = `Product Fact Sheet: ${p.name}

Key Specifications:
- Viscosity: ${p.tds.fields['Viscosity (cP)'] || 'Refer TDS'} cP
- Specific Gravity: ${p.tds.fields['Specific Gravity'] || 'Refer TDS'}
- Safety: ${p.sds.fields['GHS Classification'] || 'Refer SDS'}

Always consult the latest TDS (${p.tds.version}) and SDS (${p.sds.version}) before use.`;
      } else if (type === 'Marketing Summary') {
        text = `${p.name} — Performance Overview

Highlights:
- Reliable performance with viscosity ${p.tds.fields['Viscosity (cP)'] || 'per TDS'} cP
- ${p.category} optimized for industrial applications
- Backed by compliance (${p.sds.fields['GHS Classification'] || 'see SDS'})

Contact our team for application support.`;
      } else {
        const alt = products.find((x) => x.id !== p.id) || p;
        text = `Comparison Brief: ${p.name} vs ${alt.name}

Viscosity: ${p.tds.fields['Viscosity (cP)'] || 'N/A'} cP vs ${alt.tds.fields['Viscosity (cP)'] || 'N/A'} cP
Safety Class: ${p.sds.fields['GHS Classification'] || 'N/A'} vs ${alt.sds.fields['GHS Classification'] || 'N/A'}

Recommendation depends on flow requirements and safety constraints.`;
      }
      setOutput(text);
      setMetrics((m) => ({ ...m, contentGenerated: m.contentGenerated + 1 }));
    };

    return (
      <div className="p-6 space-y-6">
        <SectionHeader title="AI Content Generator" subtitle="Generate compliant fact sheets, summaries, and comparison briefs grounded in approved TDS & SDS." />
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 space-y-4 shadow-sm">
            <div>
              <div className="text-slate-300 text-sm mb-1">Select Product</div>
              <select value={selected} onChange={(e) => setSelected(e.target.value)} className="w-full bg-slate-950/30 rounded-lg px-3 py-2 text-slate-200 ring-1 ring-white/10 focus:ring-white/20 outline-none">
                {products.map((p) => (
                  <option key={p.id} value={p.id}>
                    {p.name}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <div className="text-slate-300 text-sm mb-1">Content Type</div>
              <select value={type} onChange={(e) => setType(e.target.value as any)} className="w-full bg-slate-950/30 rounded-lg px-3 py-2 text-slate-200 ring-1 ring-white/10 focus:ring-white/20 outline-none">
                <option>Fact Sheet</option>
                <option>Marketing Summary</option>
                <option>Comparison Brief</option>
              </select>
            </div>
            <button onClick={generate} className="w-full px-4 py-2 rounded-lg bg-slate-100 hover:bg-white text-slate-900 font-medium">
              Generate
            </button>
            <div className="text-xs text-slate-400">Outputs reference current TDS/SDS versions for compliance.</div>
          </div>
          <div className="lg:col-span-2 bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
            <h3 className="text-slate-100 font-semibold mb-3">Preview</h3>
            {output ? (
              <pre className="whitespace-pre-wrap text-slate-200 bg-slate-950/30 ring-1 ring-white/10 rounded-lg p-4">{output}</pre>
            ) : (
              <div className="text-slate-400 text-sm">Select a product and type, then generate to preview content here.</div>
            )}
            {output && (
              <div className="mt-4 flex items-center gap-3">
                <button className="px-4 py-2 rounded-lg bg-white/10 hover:bg-white/20 text-slate-200">Download PDF</button>
                <button className="px-4 py-2 rounded-lg bg-white/10 hover:bg-white/20 text-slate-200">Copy to Clipboard</button>
                <span className="text-xs text-slate-400 ml-auto">Includes version tagging for audit traceability</span>
              </div>
            )}
          </div>
        </div>
      </div>
    );
  };

  const SectionHeader = ({ title, subtitle }: { title: string; subtitle: string }) => (
    <div className="flex flex-col gap-1">
      <div className="text-slate-100 text-2xl font-semibold tracking-tight">{title}</div>
      <div className="text-slate-400 text-sm">{subtitle}</div>
    </div>
  );

  const MetricCard = ({ title, value, trend }: { title: string; value: string; trend: string }) => (
    <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
      <div className="text-slate-300 text-sm">{title}</div>
      <div className="text-slate-100 text-2xl font-semibold mt-1 tracking-tight">{value}</div>
      <div className="text-slate-300 text-xs mt-1">{trend}</div>
    </div>
  );

  const TinyStat = ({ label, value, color }: { label: string; value: string; color: string }) => (
    <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-4 shadow-sm">
      <div className="flex items-center justify-between">
        <div className="text-slate-300 text-sm">{label}</div>
        <div className={`w-2 h-2 rounded-full ${color}`} />
      </div>
      <div className="text-slate-100 text-xl font-semibold mt-1">{value}</div>
    </div>
  );

  const HealthRow = ({ label, value, barClass, pct }: { label: string; value: string; barClass: string; pct: number }) => (
    <div>
      <div className="flex items-center justify-between text-sm">
        <span className="text-slate-300">{label}</span>
        <span className="text-slate-400">{value}</span>
      </div>
      <div className="w-full h-2 rounded bg-white/5 ring-1 ring-white/10 overflow-hidden mt-1">
        <div className={`h-full ${barClass}`} style={{ width: `${Math.min(100, Math.max(0, pct))}%` } as React.CSSProperties} />
      </div>
    </div>
  );

  const ActionRow = ({ label, status }: { label: string; status: 'High' | 'Medium' | 'Low' }) => (
    <div className="flex items-center justify-between bg-slate-950/30 ring-1 ring-white/10 rounded-lg p-3">
      <div className="text-slate-200">{label}</div>
      <span className="text-xs px-2 py-1 rounded bg-white/10 text-slate-100 ring-1 ring-white/10">
        {status} Priority
      </span>
    </div>
  );

  const ComparisonPanel = ({ title, subtitle, left, right }: { title: string; subtitle: string; left: Record<string, string>; right: Record<string, string> }) => {
    const keys = Array.from(new Set([...Object.keys(left), ...Object.keys(right)])).sort();
    return (
      <div className="bg-slate-950/40 ring-1 ring-white/10 rounded-xl p-5 shadow-sm">
        <div className="text-slate-100 font-semibold">{title}</div>
        <div className="text-xs text-slate-400 mb-3">{subtitle}</div>
        <div className="grid grid-cols-12 text-xs text-slate-400 px-2 py-2">
          <div className="col-span-5">Left</div>
          <div className="col-span-2 text-center">Field</div>
          <div className="col-span-5 text-right">Right</div>
        </div>
        <div className="divide-y divide-white/10">
          {keys.map((k) => {
            const lv = left[k] || '—';
            const rv = right[k] || '—';
            const diff = lv !== rv && lv !== '—' && rv !== '—';
            return (
              <div key={k} className={`grid grid-cols-12 items-center px-2 py-2 ${diff ? 'bg-white/5' : ''}`}>
                <div className={`col-span-5 ${diff ? 'text-slate-100' : 'text-slate-200'}`}>{lv}</div>
                <div className="col-span-2 text-center text-slate-400">{k}</div>
                <div className={`col-span-5 text-right ${diff ? 'text-slate-100' : 'text-slate-200'}`}>{rv}</div>
              </div>
            );
          })}
          {keys.length === 0 && <div className="text-slate-400 text-sm p-3">No fields to compare.</div>}
        </div>
      </div>
    );
  };

  const renderContent = () => {
    if (currentScreen === 'home') return <HomeDashboard />;
    if (currentScreen === 'ingestion') return <AutomateIngestionPage />;
    if (currentScreen === 'extraction') return <DataExtractionPage />;
    if (currentScreen === 'assistant') return <AgenticRAGPage />;
    if (currentScreen === 'portal') return <ProductPortalPage />;
    if (currentScreen === 'regulatory') return <RegulatoryDashboardPage />;
    if (currentScreen === 'comparison') return <ComparisonPage />;
    if (currentScreen === 'generator') return <ContentGeneratorPage />;
    return (
      <div className="p-6">
        <div className="text-slate-200">Unknown page.</div>
      </div>
    );
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-slate-950 via-slate-950 to-zinc-950 text-slate-100">
      <header className="sticky top-0 z-30 backdrop-blur border-b border-white/10 bg-slate-950/60">
        <div className="max-w-7xl mx-auto px-4 py-3 flex items-center gap-4">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg bg-white/10 ring-1 ring-white/15 flex items-center justify-center text-slate-100 font-semibold">CI</div>
            <div className="font-semibold tracking-tight">ChemOps Intelligence</div>
          </div>
          <nav className="ml-auto hidden lg:flex items-center gap-1">
            {navItems.map((n) => (
              <button
                key={n.key}
                onClick={() => setCurrentScreen(n.key)}
                className={`px-3 py-2 rounded-lg text-sm ${
                  currentScreen === n.key ? 'bg-white/10 ring-1 ring-white/20 text-slate-100' : 'hover:bg-white/5 text-slate-200'
                }`}
              >
                <span className="mr-1">{n.icon}</span>
                {n.label}
              </button>
            ))}
          </nav>
          <div className="lg:hidden ml-auto">
            <select
              value={currentScreen}
              onChange={(e) => setCurrentScreen(e.target.value as Screen)}
              className="bg-slate-950/30 rounded-lg px-3 py-2 text-slate-200 ring-1 ring-white/10"
            >
              {navItems.map((n) => (
                <option key={n.key} value={n.key}>
                  {n.icon} {n.label}
                </option>
              ))}
            </select>
          </div>
        </div>
      </header>
      <main className="max-w-7xl mx-auto">{renderContent()}</main>
      <footer className="py-6 text-center text-xs text-slate-500">
        © {new Date().getFullYear()} ChemOps Intelligence • AI-powered compliance and product experience
      </footer>
    </div>
  );
}
